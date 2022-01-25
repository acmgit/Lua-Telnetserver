--[[
************************************************************************************
**                                                                                **
**                            LUA-Telnetserver                                    **
**                                                                                **
**                              (?) by A.C.M.                                     **
**                                 GPL 3.0                                        **
**                                                                                **
************************************************************************************
]]--

local host = "localhost"
local port = 2000
local servertimeout = 0.3
local clienttimeout = 0.2
local networktimeout = 0.5

local client= {}

local socket= require("socket")
local server= assert(socket.bind(host, port))
local crlf = "\r\n"
local myip, myport = server:getsockname()
local cidx, clients = 0, 0                                  -- Clientnumber, How many clients?

server:settimeout(servertimeout)
print("Servername: " .. myip .. ":" .. myport)

-- Sends the given line to all connected Clients, except yourself
function send_2_clients(ownclient, line)
    for key, value in pairs(client) do
        if ((client[key] ~= ownclient) and (client[key] ~= nil)) then
            client[key]:send(line .. crlf)

        end -- if(client[i]

    end -- for i=

end -- function send_2_clients

print("Server is running ...")                              -- Only for info
local newclient, err, line, error
local receive= {}
local send={}

-- now the server starts
while true do
    -- is a new client connecting?
    newclient, err = server:accept()
    if((err ~= nil) and (err ~= "timeout")) then
        print(err)                                          -- Something was going wrong

    elseif (newclient ~= nil) then                          -- new Client connected
        cidx = cidx + 1
        if(cidx >= 1000) then                               -- Make a reset after 1000 Clients,
            cidx = 1                                        -- to reuse the Clientnumber again.
                                                            -- because it's a Clientindex.
        end -- if(cidx >=
        clients = clients + 1                               -- Cool, we have a new client
        newclient:settimeout(clienttimeout)
        newclient:setoption("keepalive", true)
        client[cidx] = newclient                            -- Store the client
        send_2_clients(client[cidx], "Client " .. cidx .. " is connecting!") -- Send the msg 2 all
        
        client[cidx]:send("Hello " .. cidx .. ". Welcome to the Lua-Chat!" .. crlf)
        print("Clients: " .. clients)                       -- Only for Info        
        
    end -- if((err ~=

    receive, send, error = socket.select(client, nil, clienttimeout)
    if (receive ~= nil) then                                -- ok, we have messages
        for key, value in pairs(client) do
            if (value ~= nil) then
                line, err = value:receive("*l")
                if ((err ~= nil) and (err ~= "timeout")) then
                    value:shutdown("both")
                    client[key] = nil                       -- seems connection is closed, so remove it
                    clients = clients - 1
                    send_2_clients(server, "Server: Client " .. key .. " " .. err)
                    print("Clients: " .. clients)           -- Only for Info
                    
                elseif (line ~= nil) then
                    send_2_clients(value, key .. ": " .. line)

                end -- if((err

            end -- if(line ~= nil

        end -- for i,clients

    end -- if(receive
    socket.sleep(networktimeout)

end -- while true

server:close()                                              -- I know, line is unreachable ...
