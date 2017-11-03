package model;/* Created by Oussama on 27/05/2017. */

import javax.websocket.Session;
import java.io.IOException;

public class Player {
    Session session;
    String pseudo = "";
    Integer coups = 0;
    String number;
    Boolean done = false;

    public Player(Session session) {
        this.session = session;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Session getSession() {
        return session;
    }

    public Integer getCoups() {
        return coups;
    }

    public void setCoups(Integer coups) {
        this.coups = coups;
    }

    public String getPseudo() {
        return pseudo;
    }

    public void setPseudo(String pseudo) {
        this.pseudo = pseudo;
    }

    public String test(String number) throws Exception {
        int mort = 0, blesse = 0;
        for (int i = 0; i < 4; i++) {

            if (this.number.charAt(i) == number.charAt(i)) {
                mort++;
            } else if (this.number.contains(number.substring(i, i + 1))) {
                blesse++;
            }
        }
        if (mort == 4) {
            throw new Exception();
        }
        return mort + " mort(s)<br/>" + blesse + " blessé(s)";
    }

    public void sendText(String text) {
        try {
            this.session.getBasicRemote().sendText(text);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public int incremente() {
        return coups++;
    }
}
