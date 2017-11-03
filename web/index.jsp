<%-- User: Oussama, Date: 27/05/2017, Time: 09:47 --%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <title>Guess</title>
    <!--Import Google Icon Font-->
    <link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!--Import materialize.css-->
    <link rel="stylesheet" href="ressources/css/materialize.min.css">
    <link rel="stylesheet" href="ressources/css/style.css">

    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

</head>


<body>
<!--Import jQuery before materialize.js-->
<script type="text/javascript" src="ressources/js/jquery-3.2.0.min.js"></script>
<script src="ressources/js/materialize.min.js"></script>
<div id="body">
    <nav class="teal">
        <div class="nav-wrapper">
            <a href="#" class="brand-logo">Guess the number</a>
        </div>
    </nav>
    <div class="container">
        <div class="row" style="position: relative;top: 60px;">
            <form class="col s12">
                <div class="row">
                    <div class="col m4 s12">
                        <label>Pseudo : </label>
                        <input type="text" id="pseudo" class="validate">
                    </div>
                    <div class="col m2"></div>

                    <div class=" col m6 s12">
                        <div>
                            <label>Propose a number : </label>
                        </div>
                        <input id="number1" class=" col s2 number"/>
                        <input id="number2" class="col s2 number"/>
                        <input id="number3" class="col s2 number"/>
                        <input id="number4" class="col s2 number"/>
                    </div>
                </div>
            </form>
        </div>
        <br/><br/>
        <div class="row" id="buttonGo">
            <span class="col m3"></span>
            <a class="waves-effect waves-light btn-large col m4 s12" id="playWithUs">Play</a>
            <span class="col m2"></span>
        </div>
    </div>
</div>

<script>
    var play = false;
    var myCoups = 0;
    var hisCoups = 0;
    var msgAtt = 0;
    var msgNotif = function () {
        $(".notifs").html(msgAtt);
    };
    var updateCoups = function () {
        $("#myCoups").html(myCoups);
        $("#hisCoups").html(hisCoups);
    };
    var socket = new WebSocket("ws://localhost:7979" + "/guess/play");
    var addRow = function (number, desc) {
        return "<tr><td>" + number + "</td><td>" + desc + "</td></tr>";
    };
    var initialize = function (pseudo, number) {
        socket.send(pseudo + ":" + number);
        $("#buttonGo").html("<center><div class='preloader-wrapper big active'>" +
            "<div class='spinner-layer spinner-green-only'>" +
            "<div class='circle-clipper left'><div class='circle'></div></div>" +
            "<div class='gap-patch'><div class='circle'></div></div>" +
            "<div class='circle-clipper right'><div class='circle'></div></div></div>" +
            "</center> <div><h5 class='center-align'>Waiting for players</h5></div>"
        );
        $("#pseudo").prop("disabled", true);
        for (var i = 1; i < 5; i++) {
            $("#number" + i).prop("disabled", true);
        }

        socket.onmessage = function (event) {
            if (play) {
                console.log(event.data);
                var infos = event.data.split(":");
                console.log(infos);
                if (infos[0] == "me") {
                    $("#hisHistory").append(addRow(infos[1], infos[2]));
                    hisCoups++;
                    updateCoups()
                }
                else if (infos[0] == "him") {
                    $("#myHistory").append(addRow(infos[1], infos[2]));
                    myCoups++;
                    updateCoups();
                }
                else if (infos[0] == "msg") {
                    $("#messageContainer").append('<li><span class="right">' + infos[1] + '</span><div class="clear"></div> </li>');
                    msgAtt++;
                    msgNotif();
                }
                else if (infos[0] == "end") {

                    if (infos[1] == "wait") {
                        $("#inputPlayer").html("<center><div class='preloader-wrapper big active'>" +
                            "<div class='spinner-layer spinner-green-only'>" +
                            "<div class='circle-clipper left'><div class='circle'></div></div>" +
                            "<div class='gap-patch'><div class='circle'></div></div>" +
                            "<div class='circle-clipper right'><div class='circle'></div></div></div>" +
                            "</center> <div><h5 class='center-align'>Please wait </h5></div>"
                        );
                    }
                    else {
                        if (infos[1] == "win") {
                            $("#inputPlayer").html('<center><span class="material-icons teal-text" style="font-size: 70px;"> thumb_up</span> </center><center><strong>You Win</strong></center>');
                        }
                        else if (infos[1] == "lose") {
                            $("#inputPlayer").html('<center><span class="material-icons pink-text" style="font-size: 70px;"> thumb_down</span> </center><center><strong>You Lose</strong></center>');
                        }
                        else if (infos[1] == "draw") {
                            $("#inputPlayer").html('<center><span class="material-icons pink-text" style="font-size: 70px;"> thumb_down</span><span class="material-icons teal-text" style="font-size: 70px;"> thumb_up</span> </center><center><strong>It is a draw !</strong></center>');
                        }
                        $("#inputPlayer").append('<center><a class="waves-effect waves-light btn" href="#modalReplay">Replay</a></center>');
                    }

                }
                else if (infos[0] == "start") {
                    if (infos[1] == "wait") {
                        $("#inputPlayer").html("<center><div class='preloader-wrapper big active'>" +
                            "<div class='spinner-layer spinner-green-only'>" +
                            "<div class='circle-clipper left'><div class='circle'></div></div>" +
                            "<div class='gap-patch'><div class='circle'></div></div>" +
                            "<div class='circle-clipper right'><div class='circle'></div></div></div>" +
                            "</center> <div><h5 class='center-align'>Waiting for accepting</h5></div>"
                        );
                    }
                    else if (infos[1] == "replay") {
                        $("#replayValid").modal("open");
                    }
                    else if (infos[1] == "good") {
                        console.log("Good");
                        $("#myNumber").text(myNumber);
                        myCoups = 0;
                        hisCoups = 0;
                        updateCoups();
                        $("#inputPlayer").html('<div>' +
                            '<div><label for="number">Propose a number:</label></div>' +
                            '<div id="number" class="col s12">' +
                            '<input id="number1" type="text" class=" col s2 number">' +
                            '<input id="number2" type="text" class="col s2 number">' +
                            '<input id="number3" type="text" class="col s2 number">' +
                            '<input id="number4" type="text" class="col s2 number">' +
                            '</div>' +
                            '<button class="btn center-block" id="sendNumber">' +
                            'Valider' +
                            '<i class="material-icons right">send</i>' +
                            '</button>' +
                            '</div>'
                        );
                        $("#sendNumber").click(reload);
                        viderHistory();
                    }
                }
            }
            else {
                $.get("play.jsp", function (data, status) {
                    $("#body").html(data);
                    $("#myPseudo").text(pseudo);
                    $("#myNumber").text(number);
                    $("#hisPseudo").text(event.data);

                });
                play = true;
            }
        };


    };

    var send = function (number) {
        socket.send("num:" + number);
    };


    $("#playWithUs").click(function () {
        var pseudo = $("#pseudo").val();
        var number = "";
        var regex = /^[0-9]$/;
        var bool = true;
        if (pseudo == "") {
            bool = false;
            Materialize.toast('Pseudo vide!', 4000, "rounded");
        }
        for (var i = 1; i < 5; i++) {
            var chiffre = $("#number" + i).val();
            if (regex.test(chiffre)) {
                number += chiffre;
            }
            else {
                bool = false;
                Materialize.toast('Case N:' + i + ' non valide !', 2000, "rounded");
            }
        }
        if (bool) {
            initialize(pseudo, number);
        }
    });


</script>
</body>

</html>

