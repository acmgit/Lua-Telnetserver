local host = "localhost"
local port = 22

local client= {}

local socket= require("socket")
local server= assert(socket.bind(host, port))
local timeout= 0.5
local crlf = "\r\n"
local myip, myport = server:getsockname()
local cidx, clients = 0, 0      -- How many clients?

server:settimeout(timeout)
print("Servername: " .. myip .. ":" .. myport)

function send_2_clients(ownclient, line)
    --print("Anzahl Clients: " .. cidx)
    --print("Sending: " .. line)
    for key, value in pairs(client) do
        if ((client[key] ~= ownclient) and (client[key] ~= nil)) then
            client[key]:send(line .. crlf)

        end -- if(client[i]

    end -- for i=

end -- function send_2_clients

print("Server is running ...")
local newclient, err, line, error
local receive= {}
local send={}

-- now the server starts
while true do
    -- is a new client connecting?
    newclient, err = server:accept()
    if((err ~= nil) and (err ~= "timeout")) then
        print(err)                                  -- Something was going wrong

    elseif (newclient ~= nil) then                  -- new Client connected
        cidx = cidx + 1
        if(cidx >= 10000) then
            cidx = 1 

        end
        clients = clients + 1
        newclient:settimeout(timeout)
        newclient:setoption("keepalive", true)
        client[cidx] = newclient                    -- Store the client
        send_2_clients(client[cidx], "Client " .. cidx .. " is connecting!") -- Send the msg 2 all
        client[cidx]:send("Hello " .. cidx .. ". Welcome to the Lua-Chat!" .. crlf)
        print("Clients: " .. clients)
        
    end

    receive, send, error = socket.select(client, nil, timeout)
    if (receive ~= nil) then                        -- ok, we have messages
        for key, value in pairs(client) do
            if (value ~= nil) then
                line, err = value:receive("*l")
                if ((err ~= nil) and (err ~= "timeout")) then
                    value:shutdown("both")
                    client[key] = nil                     -- seems connection is closed, so remove it
                    clients = clients - 1
                    send_2_clients(server, "Server: Client " .. key .. " " .. err)
                    print("Clients: " .. clients)
                    
                elseif (line ~= nil) then
                    --print(line)
                    send_2_clients(value, key .. ": " .. line)

                end -- if((err

            end -- if(line ~= nil

        end -- for i,clients

    end -- if(receive
    socket.sleep(timeout)

end -- while true

server:close()
