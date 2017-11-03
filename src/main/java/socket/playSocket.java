package socket;/* Created by Oussama on 27/05/2017. */


import Session.SessionHandler;
import model.Game;
import model.Player;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;

@ApplicationScoped
@ServerEndpoint("/play")
public class playSocket {


    @Inject
    private SessionHandler sessionHandler;

    @OnOpen
    public void open(Session session) {
        System.out.println("open");
        sessionHandler.waitingToPlay(session);
    }

    @OnClose
    public void close(Session session) {
        System.out.println("close");
        sessionHandler.remove(session);
    }

    @OnError
    public void onError(Throwable error) {
        System.out.println(error.getMessage());
    }

    @OnMessage
    public void handleMessage(String message, Session session) {
        System.out.println(message);


        Player player = sessionHandler.getPlayer(session);
        if (player != null) {
            String[] infos = message.split("[:]");
            player.setPseudo(infos[0]);
            player.setNumber(infos[1]);
            sessionHandler.addGame(session);
        }
        Game game = sessionHandler.getGame(session);
        if (game != null) {
            if (game.isOff) {
                game.attach();
                game.isOff = false;
            } else {
                String[] type = message.split("[:]");
                if (type[0].equals("num")) {
                    game.numberSend(session, type[1]);
                } else if (type[0].equals("msg")) {
                    game.messageSend(session, type[1]);
                } else if (type[0].equals("start")) {
                    game.restart(session, type[1]);
                }

            }

        }


    }

}
