var client = new XMLHttpRequest();
// CoRR Backend class
var backend = {
    // Main backend properties.
    cloud_url: 'https://0.0.0.0/cloud/v0.2',
    api_url: 'https://0.0.0.0/corr/api/v0.2/private',
    app_key:"",
    user_key: "",
    query_result: {},
    github: undefined,
    projects: [],
    current_project: {},

    // Sanitize function which looks for special characters that may be problematic.
    sanitize: function(data){
        for (var i = 0; i < data.length; i++) {
            var check = /[~`!#$%\^&*+=\[\]\\'/{}|\\":<>\?]/g.test(data[i]);
            if(check){
                return false;
            }
        }
        return true;
    },

    // Cors function injector.
    cors: function (method, url) {
      var xhr = new XMLHttpRequest();
      if ("withCredentials" in xhr) {

        // Check if the XMLHttpRequest object has a "withCredentials" property.
        // "withCredentials" only exists on XMLHTTPRequest2 objects.
        xhr.open(method, url, true);

      } else if (typeof XDomainRequest != "undefined") {

        // Otherwise, check if XDomainRequest.
        // XDomainRequest only exists in IE, and is IE's way of making CORS requests.
        xhr = new XDomainRequest();
        xhr.open(method, url);

      } else {

        // Otherwise, CORS is not supported by the browser.
        xhr = null;

      }
      return xhr;
    },
    // authentication function that takes care of the github sso pipeline.
    auth: function(fill) {
        console.log(this.cloud_url+"/public/oauth/PFHub/github/request");

        var xmlhttp = new XMLHttpRequest();
        xmlhttp.open("GET", this.cloud_url+"/public/oauth/PFHub/github/request", true);
        xmlhttp.onload = function() {
          console.log(xmlhttp.responseURL);
          var response = JSON.parse(xmlhttp.responseText);
          backend.github = response["github"];
          var url = response["base-url"].split("/");
          backend.app_key = url[url.length-1];
          backend.user_key = url[url.length-2];
          Cookies.set('github', backend.github);
          Cookies.set('app-key', backend.app_key);
          Cookies.set('user-key', backend.user_key);

          console.log(Cookies.get('github'));
          console.log(Cookies.get('app-key'));
          console.log(Cookies.get('user-key'));

          // console.log(response);
          if(fill != undefined){
            fill();
          }
        };

        xmlhttp.onerror = function(e) {
          console.log(xmlhttp);
          console.log('An error occured.');
          console.log(xmlhttp.statusText);
          console.log(e);
          console.log(backend.cloud_url+"/public/oauth/PFHub/github/request");
          /* If there is an error we retry authentication */
          /* When the authentication page is closed */
          var child = window.open(backend.cloud_url+"/public/oauth/PFHub/github/request", '_blank');

          // Following is commented for debugging purposes.
          // var timer = setInterval(checkChild, 1000);
          //
          // function checkChild() {
          //     // if (child.closed) {
          //     //     location.reload();
          //     //     clearInterval(timer);
          //     // }
          //     }
          // }

        };

        var github = Cookies.get('github');
        if(github != undefined){
          backend.github = github;

          var app_key = Cookies.get('app-key');
          var user_key = Cookies.get('user-key');
          backend.app_key = app_key;
          backend.user_key = user_key;

          console.log(backend.github);
          console.log(backend.app_key);
          console.log(backend.user_key);

          if(fill != undefined){
            fill();
          }
        }else{
          xmlhttp.send();
        }
    },

    // Fetch the CoRR Pfhub projects. Which are hackatons.
    hackatons: function() {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.open("GET", backend.api_url+"/"+backend.user_key+"/"+backend.app_key+"/projects");
        xmlhttp.onload = function() {
          var response = JSON.parse(xmlhttp.responseText);
          backend.projects = response['content']['projects'];
          console.log(backend.projects);
          backend.upload_fill(backend.projects);
        };

        xmlhttp.onerror = function() {
          console.log('An error occured during share.');
          console.log(xmlhttp.responseText);
        };

        xmlhttp.send();
    },

    // Retrieve all the simulations (records) of a hackaton (project)
    benchmark: function(project_id) {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.open("GET", this.api_url+"/"+this.user_key+"/"+this.app_key+"/project/records/"+project_id);
        xmlhttp.onload = function() {
          var response = JSON.parse(xmlhttp.responseText);
          backend.current_project = response;
          console.log(response);
        };

        xmlhttp.onerror = function() {
          console.log('An error occured during share.');
          console.log(xmlhttp.responseText);
        };

        xmlhttp.send();
    },

    // A mapper function. Not needed for now as we do not erase the previous
    // process.
    mapper: function (pfub_data) {
      var corr_data = pfhub_data;
      // Perform the mapping here.

      return corr_data;
    },

    // An url parameters extractor function.
    extractor: function(search_string) {
      var parse = function(params, pairs) {
        var pair = pairs[0];
        var parts = pair.split('=');
        var key = decodeURIComponent(parts[0]);
        var value = decodeURIComponent(parts.slice(1).join('='));

        // Handle multiple parameters of the same name
        if (typeof params[key] === "undefined") {
          params[key] = value;
        } else {
          params[key] = [].concat(params[key], value);
        }

        return pairs.length == 1 ? params : parse(params, pairs.slice(1))
      }
      // Get rid of leading ?
      return search_string.length == 0 ? {} : parse({}, search_string.substr(1).split('&'));
    },

    // The function that triggers the access to the uploead form.
    to_upload: function(){
      var base_url = window.location.origin;
      window.location.replace(base_url+"/pfhub/simulations/upload_form");
    },

    // The upload function from PFHub native to PFHub space in CoRR.
    upload: function() {
        var benchmark_id = document.getElementById("benchmark_id");
        var project_id = null;
        var project_name = null;
        var index;
        for(index=0; index < backend.projects.length; index ++){
          console.log(backend.projects[index]['tags']);
          if (backend.projects[index]['tags'].includes(benchmark_id.value)){
            project_id = backend.projects[index]['id'];
            project_name = backend.projects[index]['name'];
          }
        }
        if(project_id != null){
          var data = {};
          // architecture
          var arch = document.getElementById("cpu_architecture");
          var acce = document.getElementById("acc_architecture");
          var para = document.getElementById("parallel_model");
          var clock = document.getElementById("clock_rate");
          var cores = document.getElementById("cores");
          var nodes = document.getElementById("nodes");

          // efficiency
          var wall = document.getElementById("wall_time");
          var time = document.getElementById("sim_time");
          var mem = document.getElementById("memory_usage");

          // details
          var short = document.getElementById("simulation_name");
          var summ = document.getElementById("summary");
          var tag = document.getElementById("benchmark_id");

          //implementation code
          var code_name = document.getElementById("code_name");
          var sim_url = document.getElementById("sim_url");
          var sim_sha = document.getElementById("sim_sha");
          var container_url = document.getElementById("container_url");

          // scientist
          var fname = document.getElementById("first");
          var lname = document.getElementById("last");
          var email = document.getElementById("email");
          var github = document.getElementById("github_id");

          data["system"] = {};
          data["system"]["architecture"] = arch.value;
          data["system"]["cpu"] = acce.value + ", " + clock.value + " Ghz, " + cores.value + " cores, " + nodes.value + " nodes";
          data["system"]["cgpupu"] = acce.para;

          data["scientist"] = {"fname": fname.value, "lname": lname.value, "email": email.value, "github": github.value};

          data["implementation"] = {"name": code_name.value, "sim": sim_url.value, "sha": sim_sha.value, "container": container_url.value}

          data["status"] = "finished";

          data["tags"] = [tag.value];

          data["rationels"] = [summ.value, short.value];

          data["simulation-name"] = short.value;

          data["efficiency"] = {"wall": wall.value, "time": time.value, "memory": mem.value};

          console.log(data);
          var files = [];
          var xmlhttp = new XMLHttpRequest();
          xmlhttp.open("POST", backend.api_url+"/"+backend.user_key+"/"+backend.app_key+"/project/record/create/"+project_id);
          xmlhttp.onload = function() {
            var response = JSON.parse(xmlhttp.responseText);
            console.log(response);

            var record_id = response['content']['head']['id'];
            console.log(files);

            for(var idx=0; idx < files.length; idx++){
              if(files[idx]['type'] == 'file'){
                console.log(files[idx]['object']);
                backend.upload_data(files[idx]['object'], 'output', record_id);
              }
            }
          };

          xmlhttp.onerror = function() {
            console.log('An error occured during share.');
            console.log(xmlhttp.responseText);
          };

          // Processing the data files list.
          $('#data-files').find('div').each(function(){
            var innerDivId = $(this).attr('id');

            if(innerDivId != undefined && innerDivId.includes("data-file") && (innerDivId.includes("block") == true)){
              var counter = innerDivId.split("-")[3];
              var data_file_block = "data-file-"+counter;
              var data_file =  document.getElementById(data_file_block);

              if(data_file != undefined && data_file.files.length > 0){
                console.log("Data file: ", data_file.files);
                var file_meta = {};
                file_meta["type"] = "file";
                file_meta["scope"] = "data";
                file_meta["object"] = data_file;
                file_meta["name"] = document.getElementById("data-name-"+counter).value;
                file_meta["description"] = document.getElementById("data-desc-"+counter).value;
                file_meta["data-x-parse"] = document.getElementById("data-x-parse-"+counter).value;
                file_meta["data-y-parse"] = document.getElementById("data-y-parse-"+counter).value;
                if(document.getElementById("data-z-parse-"+counter).value != ""){
                  file_meta["dimension"] = "3D";
                  file_meta["data-z-parse"] = document.getElementById("data-z-parse-"+counter).value;
                }else{
                  file_meta["dimension"] = "2D";
                }
                files.push(file_meta);
              }
            }else if(innerDivId != undefined && innerDivId.includes("data-url") && (innerDivId.includes("block") == true)){
              var counter = innerDivId.split("-")[3];
              var data_url_block = "data-url-"+counter;
              var data_url =  document.getElementById(data_url_block);

              if(data_url != undefined && data_url.value != ""){
                console.log("Data url: " + data_url.value);
                var file_meta = {};
                file_meta["type"] = "url";
                file_meta["scope"] = "data";
                file_meta["object"] = data_url.value;
                file_meta["name"] = document.getElementById("data-name-"+counter).value;
                file_meta["description"] = document.getElementById("data-desc-"+counter).value;
                file_meta["data-x-parse"] = document.getElementById("data-x-parse-"+counter).value;
                file_meta["data-y-parse"] = document.getElementById("data-y-parse-"+counter).value;
                if(document.getElementById("data-z-parse-"+counter).value != ""){
                  file_meta["dimension"] = "3D";
                  file_meta["data-z-parse"] = document.getElementById("data-z-parse-"+counter).value;
                }else{
                  file_meta["dimension"] = "2D";
                }
                files.push(file_meta);
              }
            }
          });
          // Processing the media files list.
          $('#media-files').find('div').each(function(){
            var innerDivId = $(this).attr('id');
            if(innerDivId != undefined && innerDivId.includes("media-file") && (innerDivId.includes("block") == true)){
              var counter = innerDivId.split("-")[3];
              var media_file_block = "media-file-"+counter;
              var media_file =  document.getElementById(media_file_block);

              if(media_file != undefined && media_file.files.length > 0){
                console.log("Media file: ", media_file.files);
                var file_meta = {};
                file_meta["type"] = "file";
                file_meta["scope"] = "media";
                file_meta["object"] = media_file;
                file_meta["name"] = document.getElementById("media-name-"+counter).value;
                file_meta["description"] = document.getElementById("media-desc-"+counter).value;
                files.push(file_meta);
              }
            }else if(innerDivId != undefined && innerDivId.includes("media-url") && (innerDivId.includes("block") == true)){
              var counter = innerDivId.split("-")[3];
              var media_url_block = "media-url-"+counter;
              var media_url =  document.getElementById(media_url_block);

              if(media_url != undefined && media_url.value != ""){
                console.log("Media url: " + media_url.value);
                var file_meta = {};
                file_meta["type"] = "url";
                file_meta["scope"] = "media";
                file_meta["object"] = media_url.value;
                file_meta["name"] = document.getElementById("media-name-"+counter).value;
                file_meta["description"] = document.getElementById("media-desc-"+counter).value;
                files.push(file_meta);
              }
            }
          });
          data['outputs'] = [];
          for(var idx=0; idx < files.length; idx++){
            if(files[idx]['type'] == 'url'){
              var output = {'path': files[idx]['object'], 'name': files[idx]['name'], 'description': files[idx]['description'], 'metadata': {'encoding': '', 'mimetype': '', 'size': 0}};
              if(files[idx]['scope'] == "data"){
                output['dimension'] = files[idx]['dimension'];
                output['data-x-parse'] = files[idx]['data-x-parse'];
                output['data-y-parse'] = files[idx]['data-y-parse'];
                if(output['dimension'] == "3D"){
                  output['data-z-parse'] = files[idx]['data-z-parse'];
                }
              }
              data['outputs'].push(output);
            }
          }
          console.log(data);
          xmlhttp.send(JSON.stringify(data));
        }else{
          console.log("CoRR could not find this project-id: "+benchmark_id.value);
        }
    },

    // A function that is needed to handle the switch from file to url for
    // data or media items.
    switch_url2file: function(scope, counter, tofile){
      console.log("Counter: "+counter+" - File: "+tofile);
      if(tofile == true){
        var url_block = document.getElementById(scope+"-url-block-"+counter);
        url_block.classList.add("hide");
        var file_block = document.getElementById(scope+"-file-block-"+counter);
        file_block.classList.remove("hide");
      }else{
        var file_block = document.getElementById(scope+"-file-block-"+counter);
        file_block.classList.add("hide");
        var url_block = document.getElementById(scope+"-url-block-"+counter);
        url_block.classList.remove("hide");
      }
    },

    // The funtion that fills up the upload form.
    upload_fill: function(projects){
      console.log(backend.github);
      var fname = document.getElementById("first");
      var lname = document.getElementById("last");
      var email = document.getElementById("email");
      var github = document.getElementById("github_id");
      if(fname != undefined && lname != undefined && email != undefined && github != undefined){
        fname.value = backend.github['name'].split(" ").slice(0, backend.github['name'].split(" ").length - 1).join(' ');
        lname.value = backend.github['name'].split(" ")[backend.github['name'].split(" ").length - 1];
        email.value = backend.github['email'];
        github.value = backend.github['login'];

        if(projects != undefined){
          var benchmark_id = document.getElementById("benchmark_id");
          console.log("Benchmark: ", benchmark_id.value);
          console.log("Benchmarks: ", projects);
          var project_id = null;
          var project_name = null;
          var index;
          for(index=0; index < projects.length; index ++){
            console.log(projects[index]['tags']);
            if (projects[index]['tags'].includes(benchmark_id.value)){
              project_id = projects[index]['id'];
              project_name = projects[index]['name'];
            }
          }
        }
      }
    },

    // The function that uploads the data and media files to the CoRR record.
    upload_data: function(file, group, item_id) {
        console.log(file);
        var formData = new FormData();
        formData.append("file", file.files[0], file.files[0].name);
        var url_temp = this.url;

        var blobSlice = File.prototype.slice || File.prototype.mozSlice || File.prototype.webkitSlice,
            _file = file.files[0],
            chunkSize = 2097152,  // Read in chunks of 2MB
            chunks = Math.ceil(_file.size / chunkSize),
            currentChunk = 0,
            spark = new SparkMD5.ArrayBuffer(),
            fileReader = new FileReader();

        fileReader.onload = function (e) {
            spark.append(e.target.result);
            currentChunk++;

            if (currentChunk < chunks) {
                loadNext();
            } else {
                $.ajax({
                    url        : backend.api_url+"/"+backend.user_key+"/"+backend.app_key+"/file/upload/"+group+"/"+item_id+"?checksum="+spark.end(),
                    type       : "POST",
                    data       : formData,
                    async      : true,
                    cache      : false,
                    processData: false,
                    contentType: false,
                    success : function(response){
                        console.log("success!");
                        if(response == "" || response == null || response == undefined){
                            console.log("Cloud returned empty response!");
                        }else{
                            try{
                                if(response.code != 200 && response.code != 201){
                                  console.log(response.title, response.content);
                                  Materialize.toast('File: '+file.files[0].name+' upload failed', 3000, 'rounded');
                                }else{
                                    Materialize.toast('File: '+file.files[0].name+' upload succeeded', 3000, 'rounded');
                                }
                            }catch(err){
                                console.log(err);
                            }
                        }
                    },
                    error: function(xhr){
                        console.log("error!");
                    },
                    complete: function(data){
                        console.log("complete!");
                        console.log(data);
                    }
                 });
            }
        };

        fileReader.onerror = function () {
            $('#loading-modal').closeModal();
            config.error_modal('oops', 'something went wrong.');
        };

        function loadNext() {
            var start = currentChunk * chunkSize,
                end = ((start + chunkSize) >= _file.size) ? _file.size : start + chunkSize;

            fileReader.readAsArrayBuffer(blobSlice.call(_file, start, end));
        }

        loadNext();
    },

    // I don't think we need this anymore.
    corr2pfhub: function(record){
      // Convert a corr record to a meta.yaml
      return record;
    },
};
