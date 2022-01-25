# Lua-Telnetserver
A small and simple Telnet-Server written in Lua.

##Dependings:
lua-socket

##Description:
You need installed Lua and Lua-Socket in your OS. Open the console and enter


    lua Server.lua

Then start a Telnet-Client of your choice, enter the following adress:

    localhost:22

If the connection was successfull, you have now your own little chat.


## Install as daemon:
Change the IP-Adress to your IP-Adress on top of Server.lua. 
Move Server.lua to /usr/bin/.
Move Lua-Telnetserver.service to /usr/syst


    systemctl start Lua-Telnetserver

To watch the daemon


    systemctl status Lua-Telnetserver

and to stop the daemon


    systemctl stop Lua-Telnetserver


## License:

GPL 3.0

