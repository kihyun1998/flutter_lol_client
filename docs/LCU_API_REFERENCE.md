# League Client Update (LCU) API Reference

## Overview

The League Client Update (LCU) API is a REST API that allows developers to interact with the League of Legends client. This API provides access to client functionality including summoner information, champion select, match history, friends, and more.

⚠️ **Important Notice**: The LCU API is **not officially supported** by Riot Games and may change or disappear without warning. Use at your own risk.

## Authentication & Connection

- **Host**: `127.0.0.1` (localhost only)
- **Port**: Dynamic (changes on each client restart, found in lockfile)
- **Protocol**: HTTPS with self-signed certificate
- **Authentication**: HTTP Basic Auth
  - Username: `riot`
  - Password: Found in lockfile (changes on each restart)

## API Categories

### 1. Summoner APIs
Manage summoner information and account details.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/lol-summoner/v1/current-summoner` | GET | Get current logged-in summoner info |
| `/lol-summoner/v1/summoners/{summonerId}` | GET | Get summoner by ID |
| `/lol-summoner/v1/summoner-profile` | GET | Get summoner profile |

### 2. Champion Select APIs
Interact with champion select phase.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/lol-champ-select/v1/session` | GET | Get current champion select session |
| `/lol-champ-select/v1/actions` | GET | Get available actions |
| `/lol-champ-select/v1/pick-order-swaps` | GET | Get pick order swap requests |

### 3. Lobby APIs
Create and manage game lobbies.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/lol-lobby/v2/lobby` | POST | Create lobby |
| `/lol-lobby/v2/lobby` | GET | Get current lobby |
| `/lol-lobby/v2/lobby` | DELETE | Leave lobby |
| `/lol-lobby/v2/lobby/invitations` | POST | Invite players |

### 4. Match History APIs
Access match history and game data.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/lol-match-history/v1/products/lol/current-summoner/matches` | GET | Get match history |
| `/lol-match-history/v1/games/{gameId}` | GET | Get specific game details |

### 5. Friends & Social APIs
Manage friends list and social features.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/lol-chat/v1/friends` | GET | Get friends list |
| `/lol-chat/v1/conversations` | GET | Get chat conversations |
| `/lol-chat/v1/me` | GET | Get own chat status |

### 6. Game Queue & Matchmaking APIs
Interact with matchmaking queue and game flow.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/lol-gameflow/v1/gameflow-phase` | GET | Get current game phase |
| `/lol-gameflow/v1/session` | GET | Get game session info |
| `/lol-matchmaking/v1/search` | POST | Start matchmaking |
| `/lol-matchmaking/v1/search` | DELETE | Cancel matchmaking |
| `/lol-matchmaking/v1/ready-check` | GET | Get ready check status |
| `/lol-matchmaking/v1/ready-check/accept` | POST | Accept match |
| `/lol-matchmaking/v1/ready-check/decline` | POST | Decline match |

#### Game Flow Phases
- `None` - No active game
- `Lobby` - In lobby
- `Matchmaking` - Searching for match
- `ReadyCheck` - Match found, waiting for acceptance
- `ChampSelect` - Champion selection phase
- `GameStart` - Game starting
- `InProgress` - Game in progress
- `WaitingForStats` - Game ended, waiting for stats
- `PreEndOfGame` - Pre-game end
- `EndOfGame` - Game ended

### 7. Champion & Item APIs
Access champion and item data.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/lol-champions/v1/inventories/{summonerId}/champions` | GET | Get owned champions |
| `/lol-champions/v1/owned-champions-minimal` | GET | Get minimal champion data |
| `/lol-inventory/v1/champions-skins` | GET | Get champion skins |

### 8. Store & Purchase APIs
Interact with the in-game store.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/lol-store/v1/catalog` | GET | Get store catalog |
| `/lol-store/v1/wallet` | GET | Get wallet balance (RP/BE) |

### 9. Settings & Preferences APIs
Manage client settings and preferences.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/lol-game-settings/v1/game-settings` | GET | Get game settings |
| `/lol-game-settings/v1/input-settings` | GET | Get input settings |

### 10. Live Game APIs
Access information about ongoing games.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/lol-gameflow/v1/spectate/delayed-spectate` | POST | Spectate game |
| `/lol-spectator/v1/spectate/featured-games` | GET | Get featured games |

### 11. Live Client Data API (In-Game)
**⚠️ Different Port**: Runs on `https://127.0.0.1:2999` during games

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/liveclientdata/allgamedata` | GET | Complete game state data |
| `/liveclientdata/activeplayer` | GET | Current player data |
| `/liveclientdata/playerlist` | GET | All players in game |
| `/liveclientdata/playerscores` | GET | Player scores and stats |
| `/liveclientdata/playermainrunes` | GET | Player rune pages |
| `/liveclientdata/playeritems` | GET | Player item builds |
| `/liveclientdata/eventdata` | GET | Game events (kills, objectives) |
| `/liveclientdata/gamestats` | GET | Game statistics |

#### Key Data for Jungle Helper
- **Jungle Camps**: Monster spawn times, health status
- **Objectives**: Dragon, Baron, Rift Herald timers
- **Player Items**: Jungle item progression, smite availability
- **Game Time**: Precise game timer for camp calculations
- **Player Position**: Map coordinates for proximity checks

#### Example Response Structure
```json
{
  "gameData": {
    "gameTime": 847.1,
    "mapName": "Map11",
    "mapNumber": 11
  },
  "allPlayers": [
    {
      "championName": "Graves",
      "position": "JUNGLE",
      "summonerSpells": {
        "summonerSpellOne": { "displayName": "Smite" }
      }
    }
  ]
}
```

## WebSocket Events

The LCU also supports WebSocket connections for real-time events:

- **Connection**: `wss://127.0.0.1:{port}/` (same credentials as HTTP)
- **Events**: JSON-RPC 2.0 format
- **Subscriptions**: Subscribe to specific event types

### Common Event Types

| Event | Description |
|-------|-------------|
| `OnJsonApiEvent` | General API state changes |
| `OnLcuEvent` | League client events |
| `OnLog` | Client log messages |

### Key WebSocket Events for Auto-Accept & Jungle Helper

#### Auto-Accept Events
- `OnJsonApiEvent_lol-gameflow_v1_gameflow-phase` - Game flow phase changes
- `OnJsonApiEvent_lol-matchmaking_v1_ready-check` - Ready check status changes
- `OnJsonApiEvent_lol-matchmaking_v1_search` - Matchmaking search status

#### Champion Select Events  
- `OnJsonApiEvent_lol-champ-select_v1_session` - Champion select session updates
- `OnJsonApiEvent_lol-champ-select_v1_actions` - Champion select actions

#### In-Game Events
- `OnJsonApiEvent_lol-gameflow_v1_session` - Game session changes
- `OnJsonApiEvent_lol-spectator_v1_spectate` - Spectator mode events

### WebSocket Message Format
```json
[
  8,
  "OnJsonApiEvent",
  {
    "data": { /* API response data */ },
    "eventType": "Update|Create|Delete",
    "uri": "/lol-gameflow/v1/gameflow-phase"
  }
]
```

## Usage Guidelines

### ✅ Allowed
- Personal use applications
- Community tools that enhance gameplay
- Data analysis and statistics
- Educational projects

### ❌ Not Allowed
- Bypassing official Riot API rate limits
- Automated gameplay (botting)
- Selling access to LCU data
- Commercial use without approval

## Important Notes

1. **Registration Required**: Contact Riot Games before releasing any LCU-based application
2. **Approved Endpoints Only**: Only use endpoints from Riot's approved list
3. **No Guarantees**: API may change or break without notice
4. **Local Only**: API is only accessible from the same machine running League client
5. **Self-Signed Certificates**: You must handle SSL certificate validation properly

## Tools & Resources

### Community Tools
- **Rift Explorer**: Desktop app for exploring LCU endpoints
- **LCU Explorer**: Alternative endpoint explorer
- **Swagger UI**: Online API documentation viewer

### Documentation Sites
- [Hextechdocs.dev](https://hextechdocs.dev/) - Community documentation
- [Riot API Libraries](https://riot-api-libraries.readthedocs.io/) - Official library docs

## Implementation in Flutter

When implementing LCU API calls in Flutter, consider:

1. **SSL Handling**: Bypass certificate validation for self-signed certificates
2. **Dynamic Port**: Read port from lockfile on each connection
3. **Error Handling**: Robust error handling for connection failures
4. **Rate Limiting**: Implement client-side rate limiting
5. **Event Subscriptions**: Use WebSocket for real-time updates

## Example Implementation Ideas

### Basic Features
- Current summoner info display
- Match history viewer
- Champion select info
- Friends list display

### Advanced Features
- Real-time game state monitoring
- Automated champion select tools
- Custom game lobby creation
- Statistics and analytics dashboards

### Integration Features
- Third-party app integrations
- Discord bot connections
- Stream overlay data
- Performance analytics

## Implementation Guides

### 🔄 Auto-Accept Feature

**Required APIs:**
- `/lol-gameflow/v1/gameflow-phase` - Monitor game state
- `/lol-matchmaking/v1/ready-check` - Check match status  
- `/lol-matchmaking/v1/ready-check/accept` - Accept match
- WebSocket events for real-time updates

**Implementation Steps:**
1. **WebSocket Connection**: Subscribe to gameflow phase events
2. **Phase Monitoring**: Listen for `ReadyCheck` phase
3. **Auto Accept**: POST to accept endpoint when ready check appears
4. **Error Handling**: Handle network failures, client restarts

**Example Flow:**
```dart
// 1. Monitor gameflow phase
websocket.subscribe('OnJsonApiEvent_lol-gameflow_v1_gameflow-phase');

// 2. Detect ready check
if (phase == 'ReadyCheck') {
  // 3. Auto accept
  await client.post('/lol-matchmaking/v1/ready-check/accept');
}
```

### 🌲 Jungle Helper Feature

**Required APIs:**
- `/liveclientdata/allgamedata` - In-game data (port 2999)
- `/liveclientdata/eventdata` - Game events
- `/lol-gameflow/v1/session` - Game session info
- `/lol-champ-select/v1/session` - Champion select data

**Key Features:**
1. **Camp Timers**: Track jungle monster respawn times
2. **Objective Timers**: Dragon, Baron, Rift Herald countdowns  
3. **Smite Calculator**: Damage calculations based on level
4. **Route Optimization**: Suggest efficient jungle paths
5. **Enemy Jungle Tracking**: Predict enemy jungler position

**Implementation Components:**

#### 1. Camp Timer System
```dart
class JungleCamp {
  final String name;
  final Duration respawnTime;
  DateTime? lastCleared;
  
  DateTime? get nextSpawn => lastCleared?.add(respawnTime);
  Duration? get timeUntilSpawn => nextSpawn?.difference(DateTime.now());
}

// Standard jungle camp respawn times
final Map<String, Duration> campTimers = {
  'Blue Buff': Duration(minutes: 5),
  'Red Buff': Duration(minutes: 5),
  'Krugs': Duration(minutes: 2, seconds: 15),
  'Gromp': Duration(minutes: 2, seconds: 15),
  'Wolves': Duration(minutes: 2, seconds: 15),
  'Raptors': Duration(minutes: 2, seconds: 15),
};
```

#### 2. Objective Timer System  
```dart
class ObjectiveTracker {
  static const Map<String, Duration> objectiveTimers = {
    'Dragon': Duration(minutes: 5),
    'Baron': Duration(minutes: 7),
    'Rift Herald': Duration(minutes: 6),
  };
  
  DateTime? dragonKilled;
  DateTime? baronKilled;
  DateTime? heraldKilled;
}
```

#### 3. Live Data Integration
```dart
class JungleHelper {
  // Monitor game events for camp/objective kills
  void processGameEvents(List<dynamic> events) {
    for (var event in events) {
      if (event['EventName'] == 'ChampionKill') {
        // Track jungle monster deaths
        updateCampTimers(event);
      }
    }
  }
  
  // Get current game state
  Future<GameData> getLiveGameData() async {
    final response = await http.get('https://127.0.0.1:2999/liveclientdata/allgamedata');
    return GameData.fromJson(json.decode(response.body));
  }
}
```

#### 4. Smite Damage Calculator
```dart
class SmiteCalculator {
  static int getSmiteDamage(int summonerLevel) {
    // Base damage: 390 + (35 × level)
    return 390 + (35 * summonerLevel);
  }
  
  static bool canSmiteKill(int monsterHealth, int summonerLevel) {
    return monsterHealth <= getSmiteDamage(summonerLevel);
  }
}
```

**Implementation Notes:**
- Use polling for live client data (2999 port only works during games)
- Combine LCU WebSocket events with live client data
- Store timer data persistently across game sessions
- Handle game reconnections and client restarts

---

*Last updated: 2024*
*This documentation is community-maintained and not affiliated with Riot Games*