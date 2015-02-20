// check for alarms
var nodeList = document.querySelectorAll(".tempboxbad");
box = document.getElementById("topstatus");
midbox = document.getElementById("midstatus");
if (nodeList.length > 0) {
        box.className = "statusboxbad";
        box.innerHTML = nodeList.length + " alarms!";
        midbox.className = "midstatusboxbad";
        midbox.innerHTML = nodeList.length + " alarms!";
} else {
        box.className = "statusbox";
        box.innerHTML = "ALL GOOD!";
        midbox.className = "midstatusbox";
        midbox.innerHTML = "ALL GOOD!";
}
//document.getElementById('middlehouse').scrollIntoView();
