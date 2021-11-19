LoadAtlas=LoadAtlas or {}
local Atlas={}
Atlas[public.game.dezhou]={"Game/Cards","Game/Public","Game/Dz"}
Atlas[public.game.cow]={"Game/Cards","Game/Public","Game/Cows"}
Atlas[public.game.sangong]={"Game/Cards","Game/Public","Game/Sg"}
Atlas[public.game.sangongbi]={"Game/Cards","Game/Public","Game/Sg"}
Atlas[public.game.dcow]={"Game/Cards","Game/Public","Game/Cows","Game/Gcow"}
Atlas[public.brgame.sangong]={"Game/Cards","Game/BrPublic"}
Atlas[public.brgame.cow]={"Game/Cards","Game/BrPublic"}
Atlas[public.brgame.longhu]={"Game/Cards","Game/BrPublic"}
Atlas[public.brgame.shenshou]={"Game/Cards","Game/BrPublic"}
Atlas[public.brgame.baoma]={"Game/BrPublic","Game/Bcbm"}
LoadAtlas.Atlist={}
function LoadAtlas.Loading()
    LoadAtlas.Atlist=Atlas[public.entergame]
    for k,v in pairs(LoadAtlas.Atlist) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v..".plist")
    end
end
function LoadAtlas.unloading()
    for k,v in pairs(LoadAtlas.Atlist) do
        cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(v..".plist")
        cc.Director:getInstance():getTextureCache():removeTextureForKey(v..".png")
    end
    LoadAtlas.Atlist={}
end
return LoadAtlas
