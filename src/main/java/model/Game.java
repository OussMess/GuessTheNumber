package model;/* Created by Oussama on 27/05/2017. */


import javax.websocket.Session;

public class Game {

    public Boolean isOff = true;
    Player player1;
    Player player2;

    public void setPlayers(Player player1, Player player2) {
        this.player1 = player1;
        this.player2 = player2;
    }

    public void attach() {
        player1.sendText(player2.getPseudo());
        player2.sendText(player1.getPseudo());
    }

    public void numberSend(Session session, String number) {
        Player me = getPlayer(session);
        Player adverse = getAdverse(session);
        me.incremente();
        String test = null;
        try {
            test = adverse.test(number);
            if (adverse.done) {
                if (adverse.coups < me.coups) {
                    adverse.sendText("end:win");
                    me.sendText("end:lose");
                }
            }
        } catch (Exception e) {
            if (me.coups == adverse.coups && adverse.done) {
                me.sendText("end:draw");
                adverse.sendText("end:draw");
            } else if (me.coups <= adverse.coups) {
                me.sendText("end:win");
                adverse.sendText("end:lose");
            } else if (me.coups > adverse.coups) {
                me.done = true;
                me.sendText("end:wait");
            }

        } finally {
            if (test == null) {
                test = " 4 mort(s)";
            }
            me.sendText("him:" + number + ":" + test);
            adverse.sendText("me:" + number + ":" + test);
        }

    }

    public void restart(Session session, String number) {
        Player me = getPlayer(session);
        me.setNumber(number);
        me.done = false;
        me.setCoups(0);
        Player adverse = getAdverse(session);
        if (adverse.coups == 0) {
            me.sendText("start:good");
            adverse.sendText("start:good");
        } else {
            me.sendText("start:wait");
            adverse.sendText("start:replay");
        }

    }

    public void messageSend(Session session, String message) {
        Player adverse = getAdverse(session);
        adverse.sendText("msg:" + message);
    }

    private Player getPlayer(Session session) {
        if (player1.getSession() == session) {
            return player1;
        } else {
            return player2;
        }
    }

    private Player getAdverse(Session session) {
        if (player1.getSession() == session) {
            return player2;
        } else {
            return player1;
        }
    }
}
