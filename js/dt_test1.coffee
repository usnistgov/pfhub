---
---

dataSet = [[ "Tiger Nixon", "System Architect", "Edinburgh", "5421", "2011/04/25", "$320,800" ]
    [ "Garrett Winters", "Accountant", "Tokyo", "8422", "2011/07/25", "$170,750" ]
    [ "Ashton Cox", "Junior Technical Author", "San Francisco", "1562", "2009/01/12", "$86,000" ]
]


data = {
"lengthMenu": [25],
"lengthChange": false,
data: dataSet,
columns: [
  { title: "Name" }
  { title: "Position" }
  { title: "Office" }
  { title: "Extn." }
  { title: "Start date" }
  { title: "Salary" }
]
}

func = () ->
  $("#dt_test").DataTable data


$(document).ready func
