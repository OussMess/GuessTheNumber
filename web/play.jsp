<nav class="teal">
    <div class="nav-wrapper">
        <a href="#" class="brand-logo">Guess the number</a>
        <div id="w7-collapse">
            <ul id="w8" class="right hide-on-med-and-down">
                <li><a href="#">Dashboard</a></li>
                <li><a href="#">Log out</a></li>
            </ul>
        </div>
    </div>

</nav>
<ul id="slide-out" class="side-nav fixed" style="margin-top:65px;">
    <div class="chat-box">
        <div class="header teal">
            Chat
        </div>

        <div id="messages" class="messages">
            <ul id="messageContainer">

            </ul>
            <div class="clear"></div>
        </div>

        <div class="input-box">

            <textarea id="msgtext" placeholder="Enter message" style="height: 36px"></textarea>
            <button class="btn waves-effect waves-light" type="submit" style="width: 75px;vertical-align: top;"
                    id="sendmsg">
                <i class="material-icons center">send</i></button>

        </div>
    </div>
</ul>

<a style="position: absolute;right: 0;top: 20px;color: white" href="# " data-activates="slide-out"
   class="button-collapse right" id="notifsbtn"><i class="material-icons ">comment</i><span class="notifs"></span></a>

<div class="row">
    <div class="col s12" style="position: relative; top:10px">
        <div class="row">
            <div class="left">
                <span><span id="myPseudo">Ouss </span>: <strong id="myCoups">0 </strong> coups</span>

            </div>
            <div class="right">
                <span><span id="hisPseudo">Ouss </span> : <strong id="hisCoups">0 </strong> coups</span>
            </div>
        </div>
        <br/><br/>
        <div class="row" id="inputPlayer">
            <div>
                <div><label for="number">Propose a number:</label></div>
                <div id="number" class="col s12">
                    <input id="number1" type="text" class=" col s2 number">
                    <input id="number2" type="text" class="col s2 number">
                    <input id="number3" type="text" class="col s2 number">
                    <input id="number4" type="text" class="col s2 number">
                </div>
                <button class="btn center-block" id="sendNumber">
                    Valider
                    <i class="material-icons right">send</i>
                </button>

            </div>
        </div>


        <div class="row">
            <form class="col s12">
                <div class="row">
                    <div class="col s6 m4">
                        <h6 class="teal-text">your history:</h6>
                        <table class="striped">
                            <thead>
                            <tr>
                                <th>Number</th>
                                <th>Desc</th>
                            </tr>
                            </thead>
                            <tbody id="myHistory">
                            </tbody>
                        </table>

                    </div>
                    <div class="col m2"></div>
                    <div class="col s6 m4">
                        <h6 class="teal-text">his history : <strong id="myNumber">3564</strong></h6>
                        <table class="striped">
                            <thead>
                            <tr>
                                <th>Number</th>
                                <th>Desc</th>
                            </tr>
                            </thead>
                            <tbody id="hisHistory">

                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>


    </div>
</div>
<div id="modalReplay" class="modal">
    <div class="modal-content">
        <h5 class="teal-text">Propose a number :</h5>
        <div class="row">
            <div class=" col m6 s12">
                <input id="newnumber1" type="text" class="col s2 number"/>
                <input id="newnumber2" type="text" class="col s2 number"/>
                <input id="newnumber3" type="text" class="col s2 number"/>
                <input id="newnumber4" type="text" class="col s2 number"/>
            </div>
            </p>
        </div>
        <div class="modal-footer">
            <a href="#!" id="replayValid"
               class="teal white-text modal-action modal-close waves-effect waves-green btn-flat">Valid</a>
        </div>
    </div>
</div>
<script>
    var myNumber;
    $('.modal').modal();
    $('.button-collapse').sideNav({
        menuWidth: 300, // Default is 300
        edge: 'right', // Choose the horizontal origin
        closeOnClick: true, // Closes side-nav on a clicks, useful for Angular/Meteor
        draggable: true // Choose whether you can drag to open on touch screens
    });
    $("#replayValid").click(function () {
        var number = "";
        var regex = /^[0-9]$/;
        var bool = true;
        for (var i = 1; i < 5; i++) {
            var chiffre = $("#newnumber" + i).val();
            if (regex.test(chiffre)) {
                number += chiffre;
            }
            else {
                bool = false;
                Materialize.toast('Case N:' + i + ' non valide !', 2000, "rounded");
            }
        }
        if (bool) {
            myNumber = number;
            socket.send("start:" + number);
        }
    });

    var reload = function () {
        var number = "";
        var regex = /^[0-9]$/;
        var bool = true;
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
            send(number);
        }
    };
    $("#sendNumber").click(reload);
    var sendMessage = function (message) {
        $("#messageContainer").append('<li><span class="left">' + message + '</span><div class="clear"></div> </li>');
        socket.send("msg:" + message);
    };
    $("#sendmsg").click(function () {
        sendMessage($("#msgtext").val());
        $("#msgtext").val("")
    });
    $("#notifsbtn").click(function () {
        msgAtt = 0;
        $(".notifs").html("");
    });
    var viderHistory = function () {
        $("#hisHistory").html("");
        $("#myHistory").html("");
    }
</script>
