local SetupMusic = {}
    local tocar = "tocar"
    local nao_tocar = "nao_tocar"
    local json = require( "json" )

    local filePath = system.pathForFile( "music.json", system.DocumentsDirectory )

    function SetupMusic.save(value)
        local file = io.open( filePath, "w" )
        if value then
            file:write(tocar)
        else
            file:write(nao_tocar)            
        end
        io.close(file)
    end

    function SetupMusic.load()
        local file = io.open( filePath, "r" )    
        if file then
            local contents = file:read( "*a" )
            io.close( file )
            if contents == tocar then
                return true
            elseif contents == nao_tocar then
                return false 
            end               
        end
        return true
    end


return SetupMusic