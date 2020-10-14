# ExileSafeX
Private inventory at traders. Customizable size that can increase with respect increase. Deposit and withdraw items. Can block items by classname for safex.
Required for MarXet 2


Showcase video: https://www.youtube.com/watch?v=Wbb_wUnIj-0

This was developed on a test server with EXTDB2, no infistar and no battleye.


# Install Instructions:

### Client

**config.cpp**

Paste the contents into the top of your config file. Modify existing network message section if needed.
Add the lower section to InteractionMenus

**description.ext**

Paste the contents anywhere after `#include "RscDefines.hpp"` appears in your description.ext file

**initplayerlocal.sqf**

After `if (!hasInterface || isServer) exitWith {};` paste the upper contents of initplayerlocal.sqf found in the Client folder

If you are having trouble please view the example mission included.

### Server

**Code**

No overrides needed, simply pbo the server folder and place inside your servermod folder (such as @ExileServer)

**SQL**

There is a table that is needed for this to function properly. Please execute the SQL on your Exile database

**Exile.ini**

Paste the contents at the bottom of your exile.ini **MODIFY** if using extdb3


For support feel free to post in Exile Discord #support channel: https://discord.gg/cmMMHyJ

Unless something is broken or missing in this initial release I will not provide support or installation help, you are free to use this release as you wish.

Thank you!
