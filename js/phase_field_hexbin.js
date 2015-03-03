/* https://github.com/davidbau/seedrandom Copyright 2013 David Bau. */
(function(a,b,c,d,e,f){function k(a){var b,c=a.length,e=this,f=0,g=e.i=e.j=0,h=e.S=[];for(c||(a=[c++]);d>f;)h[f]=f++;for(f=0;d>f;f++)h[f]=h[g=j&g+a[f%c]+(b=h[f])],h[g]=b;(e.g=function(a){for(var b,c=0,f=e.i,g=e.j,h=e.S;a--;)b=h[f=j&f+1],c=c*d+h[j&(h[f]=h[g=j&g+b])+(h[g]=b)];return e.i=f,e.j=g,c})(d)}function l(a,b){var e,c=[],d=(typeof a)[0];if(b&&"o"==d)for(e in a)try{c.push(l(a[e],b-1))}catch(f){}return c.length?c:"s"==d?a:a+"\0"}function m(a,b){for(var d,c=a+"",e=0;c.length>e;)b[j&e]=j&(d^=19*b[j&e])+c.charCodeAt(e++);return o(b)}function n(c){try{return a.crypto.getRandomValues(c=new Uint8Array(d)),o(c)}catch(e){return[+new Date,a,a.navigator.plugins,a.screen,o(b)]}}function o(a){return String.fromCharCode.apply(0,a)}var g=c.pow(d,e),h=c.pow(2,f),i=2*h,j=d-1;c.seedrandom=function(a,f){var j=[],p=m(l(f?[a,o(b)]:0 in arguments?a:n(),3),j),q=new k(j);return m(o(q.S),b),c.random=function(){for(var a=q.g(e),b=g,c=0;h>a;)a=(a+c)*d,b*=d,c=q.g(1);for(;a>=i;)a/=2,b/=2,c>>>=1;return(a+c)/b},p},m(c.random(),b)})(this,[],Math,256,6,52);

var data = [{"url": "http://en.wikipedia.org/wiki/Phase_field_models", "image": "http://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Phase_field_order_parameter.jpg/280px-Phase_field_order_parameter.jpg", "description": "Wikipedia Phase Field Entry"}, {"url": "http://www.ctcms.nist.gov/fipy/", "image": "http://www.ctcms.nist.gov/fipy/_static/examples/phase/anisotropy/dendrite.png", "description": "FiPy Finite Volume Code"}, {"url": "http://www.mem.drexel.edu/ysun/Solidification.htm", "image": "http://www.mem.drexel.edu/ysun/files/density.png", "description": "Solidfication Simulation"}, {"url": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/research.html", "image": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/images/phase_field_shimokawabe_350_small.png", "description": "Peta-scale Phase Field Simulation"}, {"url": "https://github.com/dealii/dealii/wiki/Gallery", "image": "https://camo.githubusercontent.com/e1e7e96154e04f94f274485395d413878d3bacb5/687474703a2f2f7777772e6465616c69692e6f72672f696d616765732f77696b692f67616c6c6572792f47616c6c6572792d477261696e5f67726f7774682e706e67", "description": "Dealii Finite Element Library"}, {"url": "http://ktchu.serendipityresearch.org/research/CSE/", "image": "http://ktchu.serendipityresearch.org/research/CSE/figs/SAMR-phase_field.png", "description": "Serendipity Research"}, {"url": "http://www.comsol.com/model/phase-separation-2054", "image": "http://www.comsol.com/model/image/2054/big.png", "description": "COMSOL Finite Element Tool"}, {"url": "http://solidification.mechanical.illinois.edu/Movies/movies.html", "image": "http://solidification.mechanical.illinois.edu/Movies/Dantzig/scn1_033.gif", "description": "Binary Alloy Simulation"}, {"url": "https://www.mtm.kuleuven.be/Onderzoek/Semper/SolMicS/Research/GrainStructuresF", "image": "https://www.mtm.kuleuven.be/Onderzoek/Semper/SolMicS/Images/GGGrainanisotropic/image_preview", "description": "Evolution of Grain Structures"}, {"url": "http://www.chaos.umd.edu/gallery/pattern.html", "image": "http://www.chaos.umd.edu/gallery/spiral3.jpg", "description": "Ginzburg-Landau Equation"}, {"url": "http://www.mpie.de/index.php?id=triplejunction", "image": "http://www.mpie.de/typo3temp/pics/bbe3fe01f2.png", "description": "Modeling of Polycrystalline Microstructure Evolution"}, {"url": "http://dantzig.mechanical.illinois.edu/", "image": "http://dantzig.mechanical.illinois.edu/PFC/t24rg_rotflip.jpg", "description": "Phase Field Crystal Modeling of Microstructure"}, {"url": "http://www.uwethiele.de/", "image": "http://pauli.uni-muenster.de/~thiele/Jpg/Thie13_fig12g.jpg", "description": "Swift-Hohenberg Equation"}, {"url": "https://www.youtube.com/watch?v=0BijYlB28ME", "image": "http://i.ytimg.com/vi/0BijYlB28ME/maxresdefault.jpg", "description": "Phase Field Model for Grain Growth with Second Phase"}, {"url": "http://www.nist.gov/itl/math/hpcvg/dendrite.cfm", "image": "http://www.nist.gov/itl/math/hpcvg/upload/cover-dendrite.jpg", "description": "A Simulated Dendrite of Copper-Nickel Alloy"}, {"url": "http://users.ices.utexas.edu/~jrc/ccm/itamit/abstracts.php", "image": "http://users.ices.utexas.edu/~jrc/ccm/itamit/granasy1.jpg", "description": "Phase Field Theory of Polycrystalline Freezing"}, {"url": "http://spaceflight.esa.int/impress/text/pop-up/phase.html", "image": "http://spaceflight.esa.int/impress/text/pop-up/phase.jpg", "description": "2D Phase Field Simulations of Polycrystalline Solidification"}, {"url": "http://www.cis.kit.ac.jp/~takaki/phase/pfc1_e.html", "image": "http://www.cis.kit.ac.jp/~takaki/phase/movie/pfc1_def.gif", "description": "Phase-Field-Crystal Simulations for Solidification and Deformation"}, {"url": "http://magnetserver.cmpe.ubc.ca/wiki/index.php/Sina_Shahandeh", "image": "http://magnetserver.cmpe.ubc.ca/wiki/images/thumb/8/80/RGBLable_border_Uniform_2000.png/250px-RGBLable_border_Uniform_2000.png", "description": "Simulated grain structure using phase field method"}, {"url": "http://en.wikipedia.org/wiki/Phase_field_models", "image": "http://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Phase_field_order_parameter.jpg/280px-Phase_field_order_parameter.jpg", "description": "Wikipedia Phase Field Entry"}, {"url": "http://www.ctcms.nist.gov/fipy/", "image": "http://www.ctcms.nist.gov/fipy/_static/examples/phase/anisotropy/dendrite.png", "description": "FiPy Finite Volume Code"}, {"url": "http://www.mem.drexel.edu/ysun/Solidification.htm", "image": "http://www.mem.drexel.edu/ysun/files/density.png", "description": "Solidfication Simulation"}, {"url": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/research.html", "image": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/images/phase_field_shimokawabe_350_small.png", "description": "Peta-scale Phase Field Simulation"}, {"url": "https://github.com/dealii/dealii/wiki/Gallery", "image": "https://camo.githubusercontent.com/e1e7e96154e04f94f274485395d413878d3bacb5/687474703a2f2f7777772e6465616c69692e6f72672f696d616765732f77696b692f67616c6c6572792f47616c6c6572792d477261696e5f67726f7774682e706e67", "description": "Dealii Finite Element Library"}, {"url": "http://ktchu.serendipityresearch.org/research/CSE/", "image": "http://ktchu.serendipityresearch.org/research/CSE/figs/SAMR-phase_field.png", "description": "Serendipity Research"}, {"url": "http://www.comsol.com/model/phase-separation-2054", "image": "http://www.comsol.com/model/image/2054/big.png", "description": "COMSOL Finite Element Tool"}, {"url": "http://solidification.mechanical.illinois.edu/Movies/movies.html", "image": "http://solidification.mechanical.illinois.edu/Movies/Dantzig/scn1_033.gif", "description": "Binary Alloy Simulation"}, {"url": "https://www.mtm.kuleuven.be/Onderzoek/Semper/SolMicS/Research/GrainStructuresF", "image": "https://www.mtm.kuleuven.be/Onderzoek/Semper/SolMicS/Images/GGGrainanisotropic/image_preview", "description": "Evolution of Grain Structures"}, {"url": "http://www.chaos.umd.edu/gallery/pattern.html", "image": "http://www.chaos.umd.edu/gallery/spiral3.jpg", "description": "Ginzburg-Landau Equation"}, {"url": "http://www.mpie.de/index.php?id=triplejunction", "image": "http://www.mpie.de/typo3temp/pics/bbe3fe01f2.png", "description": "Modeling of Polycrystalline Microstructure Evolution"}, {"url": "http://dantzig.mechanical.illinois.edu/", "image": "http://dantzig.mechanical.illinois.edu/PFC/t24rg_rotflip.jpg", "description": "Phase Field Crystal Modeling of Microstructure"}, {"url": "http://www.uwethiele.de/", "image": "http://pauli.uni-muenster.de/~thiele/Jpg/Thie13_fig12g.jpg", "description": "Swift-Hohenberg Equation"}, {"url": "https://www.youtube.com/watch?v=0BijYlB28ME", "image": "http://i.ytimg.com/vi/0BijYlB28ME/maxresdefault.jpg", "description": "Phase Field Model for Grain Growth with Second Phase"}, {"url": "http://www.nist.gov/itl/math/hpcvg/dendrite.cfm", "image": "http://www.nist.gov/itl/math/hpcvg/upload/cover-dendrite.jpg", "description": "A Simulated Dendrite of Copper-Nickel Alloy"}, {"url": "http://users.ices.utexas.edu/~jrc/ccm/itamit/abstracts.php", "image": "http://users.ices.utexas.edu/~jrc/ccm/itamit/granasy1.jpg", "description": "Phase Field Theory of Polycrystalline Freezing"}, {"url": "http://spaceflight.esa.int/impress/text/pop-up/phase.html", "image": "http://spaceflight.esa.int/impress/text/pop-up/phase.jpg", "description": "2D Phase Field Simulations of Polycrystalline Solidification"}, {"url": "http://www.cis.kit.ac.jp/~takaki/phase/pfc1_e.html", "image": "http://www.cis.kit.ac.jp/~takaki/phase/movie/pfc1_def.gif", "description": "Phase-Field-Crystal Simulations for Solidification and Deformation"}, {"url": "http://magnetserver.cmpe.ubc.ca/wiki/index.php/Sina_Shahandeh", "image": "http://magnetserver.cmpe.ubc.ca/wiki/images/thumb/8/80/RGBLable_border_Uniform_2000.png/250px-RGBLable_border_Uniform_2000.png", "description": "Simulated grain structure using phase field method"}, {"url": "http://en.wikipedia.org/wiki/Phase_field_models", "image": "http://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Phase_field_order_parameter.jpg/280px-Phase_field_order_parameter.jpg", "description": "Wikipedia Phase Field Entry"}, {"url": "http://www.ctcms.nist.gov/fipy/", "image": "http://www.ctcms.nist.gov/fipy/_static/examples/phase/anisotropy/dendrite.png", "description": "FiPy Finite Volume Code"}, {"url": "http://www.mem.drexel.edu/ysun/Solidification.htm", "image": "http://www.mem.drexel.edu/ysun/files/density.png", "description": "Solidfication Simulation"}, {"url": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/research.html", "image": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/images/phase_field_shimokawabe_350_small.png", "description": "Peta-scale Phase Field Simulation"}, {"url": "https://github.com/dealii/dealii/wiki/Gallery", "image": "https://camo.githubusercontent.com/e1e7e96154e04f94f274485395d413878d3bacb5/687474703a2f2f7777772e6465616c69692e6f72672f696d616765732f77696b692f67616c6c6572792f47616c6c6572792d477261696e5f67726f7774682e706e67", "description": "Dealii Finite Element Library"}, {"url": "http://ktchu.serendipityresearch.org/research/CSE/", "image": "http://ktchu.serendipityresearch.org/research/CSE/figs/SAMR-phase_field.png", "description": "Serendipity Research"}, {"url": "http://www.comsol.com/model/phase-separation-2054", "image": "http://www.comsol.com/model/image/2054/big.png", "description": "COMSOL Finite Element Tool"}, {"url": "http://solidification.mechanical.illinois.edu/Movies/movies.html", "image": "http://solidification.mechanical.illinois.edu/Movies/Dantzig/scn1_033.gif", "description": "Binary Alloy Simulation"}, {"url": "https://www.mtm.kuleuven.be/Onderzoek/Semper/SolMicS/Research/GrainStructuresF", "image": "https://www.mtm.kuleuven.be/Onderzoek/Semper/SolMicS/Images/GGGrainanisotropic/image_preview", "description": "Evolution of Grain Structures"}, {"url": "http://www.chaos.umd.edu/gallery/pattern.html", "image": "http://www.chaos.umd.edu/gallery/spiral3.jpg", "description": "Ginzburg-Landau Equation"}, {"url": "http://www.mpie.de/index.php?id=triplejunction", "image": "http://www.mpie.de/typo3temp/pics/bbe3fe01f2.png", "description": "Modeling of Polycrystalline Microstructure Evolution"}, {"url": "http://dantzig.mechanical.illinois.edu/", "image": "http://dantzig.mechanical.illinois.edu/PFC/t24rg_rotflip.jpg", "description": "Phase Field Crystal Modeling of Microstructure"}, {"url": "http://www.uwethiele.de/", "image": "http://pauli.uni-muenster.de/~thiele/Jpg/Thie13_fig12g.jpg", "description": "Swift-Hohenberg Equation"}, {"url": "https://www.youtube.com/watch?v=0BijYlB28ME", "image": "http://i.ytimg.com/vi/0BijYlB28ME/maxresdefault.jpg", "description": "Phase Field Model for Grain Growth with Second Phase"}, {"url": "http://www.nist.gov/itl/math/hpcvg/dendrite.cfm", "image": "http://www.nist.gov/itl/math/hpcvg/upload/cover-dendrite.jpg", "description": "A Simulated Dendrite of Copper-Nickel Alloy"}, {"url": "http://users.ices.utexas.edu/~jrc/ccm/itamit/abstracts.php", "image": "http://users.ices.utexas.edu/~jrc/ccm/itamit/granasy1.jpg", "description": "Phase Field Theory of Polycrystalline Freezing"}, {"url": "http://spaceflight.esa.int/impress/text/pop-up/phase.html", "image": "http://spaceflight.esa.int/impress/text/pop-up/phase.jpg", "description": "2D Phase Field Simulations of Polycrystalline Solidification"}, {"url": "http://www.cis.kit.ac.jp/~takaki/phase/pfc1_e.html", "image": "http://www.cis.kit.ac.jp/~takaki/phase/movie/pfc1_def.gif", "description": "Phase-Field-Crystal Simulations for Solidification and Deformation"}, {"url": "http://magnetserver.cmpe.ubc.ca/wiki/index.php/Sina_Shahandeh", "image": "http://magnetserver.cmpe.ubc.ca/wiki/images/thumb/8/80/RGBLable_border_Uniform_2000.png/250px-RGBLable_border_Uniform_2000.png", "description": "Simulated grain structure using phase field method"}, {"url": "http://en.wikipedia.org/wiki/Phase_field_models", "image": "http://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Phase_field_order_parameter.jpg/280px-Phase_field_order_parameter.jpg", "description": "Wikipedia Phase Field Entry"}, {"url": "http://www.ctcms.nist.gov/fipy/", "image": "http://www.ctcms.nist.gov/fipy/_static/examples/phase/anisotropy/dendrite.png", "description": "FiPy Finite Volume Code"}, {"url": "http://www.mem.drexel.edu/ysun/Solidification.htm", "image": "http://www.mem.drexel.edu/ysun/files/density.png", "description": "Solidfication Simulation"}, {"url": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/research.html", "image": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/images/phase_field_shimokawabe_350_small.png", "description": "Peta-scale Phase Field Simulation"}, {"url": "https://github.com/dealii/dealii/wiki/Gallery", "image": "https://camo.githubusercontent.com/e1e7e96154e04f94f274485395d413878d3bacb5/687474703a2f2f7777772e6465616c69692e6f72672f696d616765732f77696b692f67616c6c6572792f47616c6c6572792d477261696e5f67726f7774682e706e67", "description": "Dealii Finite Element Library"}, {"url": "http://ktchu.serendipityresearch.org/research/CSE/", "image": "http://ktchu.serendipityresearch.org/research/CSE/figs/SAMR-phase_field.png", "description": "Serendipity Research"}, {"url": "http://www.comsol.com/model/phase-separation-2054", "image": "http://www.comsol.com/model/image/2054/big.png", "description": "COMSOL Finite Element Tool"}, {"url": "http://solidification.mechanical.illinois.edu/Movies/movies.html", "image": "http://solidification.mechanical.illinois.edu/Movies/Dantzig/scn1_033.gif", "description": "Binary Alloy Simulation"}, {"url": "https://www.mtm.kuleuven.be/Onderzoek/Semper/SolMicS/Research/GrainStructuresF", "image": "https://www.mtm.kuleuven.be/Onderzoek/Semper/SolMicS/Images/GGGrainanisotropic/image_preview", "description": "Evolution of Grain Structures"}, {"url": "http://www.chaos.umd.edu/gallery/pattern.html", "image": "http://www.chaos.umd.edu/gallery/spiral3.jpg", "description": "Ginzburg-Landau Equation"}, {"url": "http://www.mpie.de/index.php?id=triplejunction", "image": "http://www.mpie.de/typo3temp/pics/bbe3fe01f2.png", "description": "Modeling of Polycrystalline Microstructure Evolution"}, {"url": "http://dantzig.mechanical.illinois.edu/", "image": "http://dantzig.mechanical.illinois.edu/PFC/t24rg_rotflip.jpg", "description": "Phase Field Crystal Modeling of Microstructure"}, {"url": "http://www.uwethiele.de/", "image": "http://pauli.uni-muenster.de/~thiele/Jpg/Thie13_fig12g.jpg", "description": "Swift-Hohenberg Equation"}, {"url": "https://www.youtube.com/watch?v=0BijYlB28ME", "image": "http://i.ytimg.com/vi/0BijYlB28ME/maxresdefault.jpg", "description": "Phase Field Model for Grain Growth with Second Phase"}, {"url": "http://www.nist.gov/itl/math/hpcvg/dendrite.cfm", "image": "http://www.nist.gov/itl/math/hpcvg/upload/cover-dendrite.jpg", "description": "A Simulated Dendrite of Copper-Nickel Alloy"}, {"url": "http://users.ices.utexas.edu/~jrc/ccm/itamit/abstracts.php", "image": "http://users.ices.utexas.edu/~jrc/ccm/itamit/granasy1.jpg", "description": "Phase Field Theory of Polycrystalline Freezing"}, {"url": "http://spaceflight.esa.int/impress/text/pop-up/phase.html", "image": "http://spaceflight.esa.int/impress/text/pop-up/phase.jpg", "description": "2D Phase Field Simulations of Polycrystalline Solidification"}, {"url": "http://www.cis.kit.ac.jp/~takaki/phase/pfc1_e.html", "image": "http://www.cis.kit.ac.jp/~takaki/phase/movie/pfc1_def.gif", "description": "Phase-Field-Crystal Simulations for Solidification and Deformation"}, {"url": "http://magnetserver.cmpe.ubc.ca/wiki/index.php/Sina_Shahandeh", "image": "http://magnetserver.cmpe.ubc.ca/wiki/images/thumb/8/80/RGBLable_border_Uniform_2000.png/250px-RGBLable_border_Uniform_2000.png", "description": "Simulated grain structure using phase field method"}, {"url": "http://en.wikipedia.org/wiki/Phase_field_models", "image": "http://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Phase_field_order_parameter.jpg/280px-Phase_field_order_parameter.jpg", "description": "Wikipedia Phase Field Entry"}, {"url": "http://www.ctcms.nist.gov/fipy/", "image": "http://www.ctcms.nist.gov/fipy/_static/examples/phase/anisotropy/dendrite.png", "description": "FiPy Finite Volume Code"}, {"url": "http://www.mem.drexel.edu/ysun/Solidification.htm", "image": "http://www.mem.drexel.edu/ysun/files/density.png", "description": "Solidfication Simulation"}, {"url": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/research.html", "image": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/images/phase_field_shimokawabe_350_small.png", "description": "Peta-scale Phase Field Simulation"}, {"url": "https://github.com/dealii/dealii/wiki/Gallery", "image": "https://camo.githubusercontent.com/e1e7e96154e04f94f274485395d413878d3bacb5/687474703a2f2f7777772e6465616c69692e6f72672f696d616765732f77696b692f67616c6c6572792f47616c6c6572792d477261696e5f67726f7774682e706e67", "description": "Dealii Finite Element Library"}, {"url": "http://ktchu.serendipityresearch.org/research/CSE/", "image": "http://ktchu.serendipityresearch.org/research/CSE/figs/SAMR-phase_field.png", "description": "Serendipity Research"}, {"url": "http://www.comsol.com/model/phase-separation-2054", "image": "http://www.comsol.com/model/image/2054/big.png", "description": "COMSOL Finite Element Tool"}, {"url": "http://solidification.mechanical.illinois.edu/Movies/movies.html", "image": "http://solidification.mechanical.illinois.edu/Movies/Dantzig/scn1_033.gif", "description": "Binary Alloy Simulation"}, {"url": "https://www.mtm.kuleuven.be/Onderzoek/Semper/SolMicS/Research/GrainStructuresF", "image": "https://www.mtm.kuleuven.be/Onderzoek/Semper/SolMicS/Images/GGGrainanisotropic/image_preview", "description": "Evolution of Grain Structures"}, {"url": "http://www.chaos.umd.edu/gallery/pattern.html", "image": "http://www.chaos.umd.edu/gallery/spiral3.jpg", "description": "Ginzburg-Landau Equation"}, {"url": "http://www.mpie.de/index.php?id=triplejunction", "image": "http://www.mpie.de/typo3temp/pics/bbe3fe01f2.png", "description": "Modeling of Polycrystalline Microstructure Evolution"}, {"url": "http://dantzig.mechanical.illinois.edu/", "image": "http://dantzig.mechanical.illinois.edu/PFC/t24rg_rotflip.jpg", "description": "Phase Field Crystal Modeling of Microstructure"}, {"url": "http://www.uwethiele.de/", "image": "http://pauli.uni-muenster.de/~thiele/Jpg/Thie13_fig12g.jpg", "description": "Swift-Hohenberg Equation"}, {"url": "https://www.youtube.com/watch?v=0BijYlB28ME", "image": "http://i.ytimg.com/vi/0BijYlB28ME/maxresdefault.jpg", "description": "Phase Field Model for Grain Growth with Second Phase"}, {"url": "http://www.nist.gov/itl/math/hpcvg/dendrite.cfm", "image": "http://www.nist.gov/itl/math/hpcvg/upload/cover-dendrite.jpg", "description": "A Simulated Dendrite of Copper-Nickel Alloy"}, {"url": "http://users.ices.utexas.edu/~jrc/ccm/itamit/abstracts.php", "image": "http://users.ices.utexas.edu/~jrc/ccm/itamit/granasy1.jpg", "description": "Phase Field Theory of Polycrystalline Freezing"}, {"url": "http://spaceflight.esa.int/impress/text/pop-up/phase.html", "image": "http://spaceflight.esa.int/impress/text/pop-up/phase.jpg", "description": "2D Phase Field Simulations of Polycrystalline Solidification"}, {"url": "http://www.cis.kit.ac.jp/~takaki/phase/pfc1_e.html", "image": "http://www.cis.kit.ac.jp/~takaki/phase/movie/pfc1_def.gif", "description": "Phase-Field-Crystal Simulations for Solidification and Deformation"}, {"url": "http://magnetserver.cmpe.ubc.ca/wiki/index.php/Sina_Shahandeh", "image": "http://magnetserver.cmpe.ubc.ca/wiki/images/thumb/8/80/RGBLable_border_Uniform_2000.png/250px-RGBLable_border_Uniform_2000.png", "description": "Simulated grain structure using phase field method"}, {"url": "http://en.wikipedia.org/wiki/Phase_field_models", "image": "http://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Phase_field_order_parameter.jpg/280px-Phase_field_order_parameter.jpg", "description": "Wikipedia Phase Field Entry"}, {"url": "http://www.ctcms.nist.gov/fipy/", "image": "http://www.ctcms.nist.gov/fipy/_static/examples/phase/anisotropy/dendrite.png", "description": "FiPy Finite Volume Code"}, {"url": "http://www.mem.drexel.edu/ysun/Solidification.htm", "image": "http://www.mem.drexel.edu/ysun/files/density.png", "description": "Solidfication Simulation"}, {"url": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/research.html", "image": "http://www.sim.gsic.titech.ac.jp/Japanese/Member/shimokawabe/images/phase_field_shimokawabe_350_small.png", "description": "Peta-scale Phase Field Simulation"}, {"url": "https://github.com/dealii/dealii/wiki/Gallery", "image": "https://camo.githubusercontent.com/e1e7e96154e04f94f274485395d413878d3bacb5/687474703a2f2f7777772e6465616c69692e6f72672f696d616765732f77696b692f67616c6c6572792f47616c6c6572792d477261696e5f67726f7774682e706e67", "description": "Dealii Finite Element Library"}];

data.forEach(function(d, i) {
  d.i = i % 10;
  d.j = i / 10 | 0;
});

Math.seedrandom(+d3.time.hour(new Date));

d3.shuffle(data);

var height = 360,
    imageWidth = 173,
    imageHeight = 200,
    radius = 100,
    depth = 3;

var currentFocus = [innerWidth / 2, height / 2],
    desiredFocus,
    idle = true;

var style = document.body.style,
    transform = ("webkitTransform" in style ? "-webkit-"
        : "MozTransform" in style ? "-moz-"
        : "msTransform" in style ? "-ms-"
        : "OTransform" in style ? "-o-"
        : "") + "transform";

var hexbin = d3.hexbin()
    .radius(radius);

if (!("ontouchstart" in document)) d3.select("#examples")
    .on("mousemove", mousemoved);

var deep = d3.select("#examples-deep");

var canvas = deep.append("canvas")
    .attr("height", height);

context = canvas.node().getContext("2d");

var svg = deep.append("svg")
    .attr("height", height);

var mesh = svg.append("path")
    .attr("class", "example-mesh");

var anchor = svg.append("g")
      .attr("class", "example-anchor")
    .selectAll("a");

var graphic = deep.selectAll("svg,canvas");

var image = new Image;
image.src = 'images/hexbin.jpg';
image.onload = resized;

d3.select(window)
    .on("resize", resized)
    .each(resized);


function drawImage(d) {
    context.save();
    context.beginPath();
    context.moveTo(0, -radius);

    for (var i = 1; i < 6; ++i) {
        var angle = i * Math.PI / 3,
        x = Math.sin(angle) * radius,
        y = -Math.cos(angle) * radius;
        context.lineTo(x, y);
    }

    context.clip();
    // There is too much color
    context.globalAlpha = .5;
  
    context.drawImage(image,
                      imageWidth * d.i, imageHeight * d.j,
                      imageWidth, imageHeight,
                      -imageWidth / 2, -imageHeight / 2,
                      imageWidth, imageHeight);
    
    
    context.restore();
}

function resized() {
  var deepWidth = innerWidth * (depth + 1) / depth,
      deepHeight = height * (depth + 1) / depth,
      centers = hexbin.size([deepWidth, deepHeight]).centers();

  desiredFocus = [innerWidth / 2, height / 2];
  moved();

  graphic
      .style("left", Math.round((innerWidth - deepWidth) / 2) + "px")
      .style("top", Math.round((height - deepHeight) / 2) + "px")
      .attr("width", deepWidth)
      .attr("height", deepHeight);

  centers.forEach(function(center, i) {
    center.j = Math.round(center[1] / (radius * 1.5));
    center.i = Math.round((center[0] - (center.j & 1) * radius * Math.sin(Math.PI / 3)) / (radius * 2 * Math.sin(Math.PI / 3)));
    context.save();
    context.translate(Math.round(center[0]), Math.round(center[1]));
    drawImage(center.example = data[(center.i % 10) + ((center.j + (center.i / 10 & 1) * 5) % 10) * 10]);
    context.restore();
  });

  mesh.attr("d", hexbin.mesh);

  anchor = anchor.data(centers, function(d) { return d.i + "," + d.j; });

  anchor.exit().remove();

  anchor.enter().append("a")
      .attr("xlink:href", function(d) { return d.example.url; })
      .attr("xlink:title", function(d) { return d.example.description; })
    .append("path")
      .attr("d", hexbin.hexagon());

  anchor
      .attr("transform", function(d) { return "translate(" + d + ")"; });
}

function mousemoved() {
  var m = d3.mouse(this);

  desiredFocus = [
    Math.round((m[0] - innerWidth / 2) / depth) * depth + innerWidth / 2,
    Math.round((m[1] - height / 2) / depth) * depth + height / 2
  ];

  moved();
}

function moved() {
  if (idle) d3.timer(function() {
    if (idle = Math.abs(desiredFocus[0] - currentFocus[0]) < .5 && Math.abs(desiredFocus[1] - currentFocus[1]) < .5) currentFocus = desiredFocus;
    else currentFocus[0] += (desiredFocus[0] - currentFocus[0]) * .14, currentFocus[1] += (desiredFocus[1] - currentFocus[1]) * .14;
    deep.style(transform, "translate(" + (innerWidth / 2 - currentFocus[0]) / depth + "px," + (height / 2 - currentFocus[1]) / depth + "px)");
    return idle;
  });
}



