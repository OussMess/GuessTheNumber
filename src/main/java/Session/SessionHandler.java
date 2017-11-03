package Session;/* Created by Oussama on 27/05/2017. */


import model.Game;
import model.Player;

import javax.enterprise.context.ApplicationScoped;
import javax.websocket.Session;
import java.util.HashMap;
import java.util.Map;

@ApplicationScoped

public class SessionHandler {

    private Map<Session, Game> games = new HashMap<Session, Game>();
    private Map<Session, Player> waitingForPlayer = new HashMap<Session, Player>();

    public Game getGame(Session session) {
        return games.get(session);
    }

    public void waitingToPlay(Session session) {
        Player player = new Player(session);
        System.out.println("###In the Waiting List###");
        waitingForPlayer.put(session, player);
    }

    public Player getPlayer(Session session) {
        return waitingForPlayer.get(session);
    }

    public void addGame(Session session) {

        if (waitingForPlayer.size() > 1) {
            System.out.println("###Greate a Game###");
            Game game = new Game();
            Player player1 = waitingForPlayer.get(session);
            Player player2 = null;
            for (Session session1 : waitingForPlayer.keySet()) {
                if (session1 != session) {
                    player2 = waitingForPlayer.get(session1);
                    if (player2.getPseudo().isEmpty()) {
                        System.out.println("###Waiting for other players###");
                        return;
                    }
                    break;
                }
            }
            game.setPlayers(waitingForPlayer.get(session), player2);
            addGames(player1, game);
            addGames(player2, game);
        } else {
            System.out.println("###Waiting for other players###");
        }

    }

    public void addGames(Player player, Game game) {
        games.put(player.getSession(), game);
        waitingForPlayer.remove(player.getSession());
    }

    public void remove(Session session) {
        games.remove(session);
        waitingForPlayer.remove(session);
    }

}
