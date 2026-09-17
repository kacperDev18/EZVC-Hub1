-- EZVC Hub v2.1 - Fixed Macro Statistics + hidden mode
local TS=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("ReplicatedStorage")
local HS=game:GetService("HttpService")
local VU=game:GetService("VirtualUser")
local PLR=game:GetService("Players").LocalPlayer
local PG=PLR:FindFirstChild("PlayerGui") or PLR:WaitForChild("PlayerGui")
local Conns={}
local function ac(c) Conns[#Conns+1]=c return c end
local function cleanConns()
    for _,c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
    Conns={}
end
local FO="tdmacro/"
local CF=FO.."config.json"
pcall(function()
    if type(isfolder)=="function" and type(makefolder)=="function" and not isfolder(FO) then
        makefolder(FO)
    end
end)
local function wj(p,d)
    if type(writefile)~="function" then return false end
    local ok,s=pcall(function() return HS:JSONEncode(d) end)
    if not ok then return false end
    return pcall(writefile,p,s)
end
local function rj(p)
    if type(isfile)~="function" or type(readfile)~="function" or not isfile(p) then return nil end
    local ok,d=pcall(readfile,p)
    if not ok then return nil end
    local ok2,a=pcall(function() return HS:JSONDecode(d) end)
    if not ok2 or type(a)~="table" then return nil end
    return a
end
local function lf()
    if type(listfiles)~="function" then return {} end
    local seen,n={},{}
    for _,p in ipairs({FO,"tdmacro","./tdmacro/"}) do
        local ok,list=pcall(listfiles,p)
        if ok and type(list)=="table" then
            for _,f in ipairs(list) do
                local x=tostring(f):match("([^/\\]+)%.json$")
                if x and x~="state" and x~="config" and not seen[x] then
                    seen[x]=true n[#n+1]=x
                end
            end
        end
    end
    return n
end
local function sanitizeAction(a)
    if type(a)~="table" then return nil end
    a.Method=nil a.method=nil
    if a.t~="P" and a.t~="U" and a.t~="S" and a.t~="W" and a.t~="G" then return nil end
    return a
end
local function loadMacro(name)
    if not name or name=="" then return nil end
    local data=rj(FO..name..".json")
    if type(data)~="table" then return nil end
    local clean={}
    for _,a in ipairs(data) do
        local s=sanitizeAction(a)
        if s then clean[#clean+1]=s end
    end
    return clean
end
local Cfg={}
do
    local c=rj(CF)
    if c and type(c)=="table" then Cfg=c end
end
for k,v in pairs({gs="1",mn="",sel="",sk=false,rp=false,lb=false,rec=false,pl=false,s10=false,s1=false,spn=false,afk=false,oc=false,crate="Free",acr=155,acg=120,acb=255}) do
    if Cfg[k]==nil then Cfg[k]=v end
end
local _init=true
local _pend=false
local function save()
    if _init or _pend then return end
    _pend=true
    task.spawn(function()
        task.wait(0.2)
        _pend=false
        pcall(function() wj(CF,Cfg) end)
    end)
end
local function set(k,v) Cfg[k]=v save() end
local BG=Color3.fromRGB(16,16,20)
local SF=Color3.fromRGB(22,22,27)
local HD=Color3.fromRGB(26,26,32)
local PN=Color3.fromRGB(30,30,36)
local EL=Color3.fromRGB(38,38,45)
local BR=Color3.fromRGB(52,52,60)
local TX=Color3.fromRGB(238,238,244)
local SB=Color3.fromRGB(150,150,162)
local MT=Color3.fromRGB(98,98,110)
local OFF=Color3.fromRGB(52,52,60)
local AC=Color3.fromRGB(tonumber(Cfg.acr) or 155, tonumber(Cfg.acg) or 120, tonumber(Cfg.acb) or 255)
local par
pcall(function() if gethui then local ok,h=pcall(gethui) if ok and h then par=h end end end)
par=par or game:GetService("CoreGui")
for _,v in ipairs(par:GetChildren()) do
    if v.Name=="EZVCProto" then pcall(function() v:Destroy() end) end
end
local sg=Instance.new("ScreenGui")
sg.Name="EZVCProto"
sg.IgnoreGuiInset=true
sg.ResetOnSpawn=false
sg.DisplayOrder=999
sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
sg.Parent=par
local function mk(c,p,r)
    local o=Instance.new(c)
    for k,v in next,p do o[k]=v end
    if r then o.Parent=r end
    return o
end
local function cr(o,r) mk("UICorner",{CornerRadius=UDim.new(0,r)},o) end
local function sk(o,c,t) return mk("UIStroke",{Color=c,Thickness=1,Transparency=t},o) end
local function lb(p,t,x,y,w,h,c,s,b)
    return mk("TextLabel",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BackgroundTransparency=1,Font=b and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=s or 11,TextColor3=c,TextXAlignment=Enum.TextXAlignment.Left,Text=t},p)
end
local tRefs={}
local function rT(p,f,prop)
    tRefs[#tRefs+1]={p=p,f=f,prop=prop or "BackgroundColor3"}
    return p
end
local function setAC(c)
    AC=c
    for i=#tRefs,1,-1 do
        local e=tRefs[i]
        if not e.p or not e.p.Parent then
            table.remove(tRefs,i)
        else
            local v=e.f and e.f() or c
            pcall(function()
                TS:Create(e.p,TweenInfo.new(0.28,Enum.EasingStyle.Quart),{[e.prop]=v}):Play()
            end)
        end
    end
end
local function instantApply()
    for _,e in ipairs(tRefs) do
        if e.p and e.p.Parent then
            local v=e.f and e.f() or AC
            pcall(function() e.p[e.prop]=v end)
        end
    end
end
local win=mk("Frame",{Size=UDim2.fromOffset(420,300),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=BG,BorderSizePixel=0},sg)
cr(win,12)
local wS=sk(win,BR,0.35)
local function fit()
    pcall(function()
        local cam=workspace.CurrentCamera
        if not cam then return end
        local vp=cam.ViewportSize
        if vp.X<=0 or vp.Y<=0 then return end
        win.Size=UDim2.fromOffset(math.clamp(math.floor(vp.X*0.92),300,460),math.clamp(math.floor(vp.Y*0.78),260,340))
        win.Position=UDim2.new(0.5,0,0.5,0)
    end)
end
fit()
pcall(function() ac(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)) end)
local hdr=mk("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=HD,BorderSizePixel=0},win)
cr(hdr,12)
mk("Frame",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),BackgroundColor3=HD,BorderSizePixel=0},hdr)
local aDot=mk("Frame",{Size=UDim2.fromOffset(10,10),Position=UDim2.new(0,14,0.5,-5),BackgroundColor3=AC,BorderSizePixel=0},hdr)
cr(aDot,3)
rT(aDot)
lb(hdr,"EZVC Hub",30,0,120,38,TX,13,true)
lb(hdr,"v2.1",92,0,90,38,MT,9,false)
local xb=mk("TextButton",{Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-30,0.5,-12),BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=SB,Text="X",AutoButtonColor=false},hdr)
cr(xb,6)
ac(xb.MouseEnter:Connect(function() TS:Create(xb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(200,90,90),TextColor3=Color3.new(1,1,1)}):Play() end))
ac(xb.MouseLeave:Connect(function() TS:Create(xb,TweenInfo.new(0.15),{BackgroundColor3=EL,TextColor3=SB}):Play() end))
local dg,d0,d1=false,nil,nil
ac(hdr.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dg=true d0=i.Position d1=win.Position
    end
end))
ac(UIS.InputChanged:Connect(function(i)
    if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-d0
        win.Position=UDim2.new(d1.X.Scale,d1.X.Offset+d.X,d1.Y.Scale,d1.Y.Offset+d.Y)
    end
end))
ac(UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end
end))
local body=mk("Frame",{Size=UDim2.new(1,0,1,-38),Position=UDim2.new(0,0,0,38),BackgroundTransparency=1},win)
local sideBar=mk("Frame",{Size=UDim2.new(0,118,1,0),BackgroundColor3=SF,BorderSizePixel=0},body)
mk("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=BR,BackgroundTransparency=0.4,BorderSizePixel=0},sideBar)
local ct=mk("Frame",{Size=UDim2.new(1,-118,1,0),Position=UDim2.new(0,118,0,0),BackgroundTransparency=1},body)
local accentLine=mk("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,0,0),BackgroundColor3=AC,BorderSizePixel=0,ZIndex=10},body)
rT(accentLine)
local pages,tabs,tabInds,cur={},{},{},nil
local function go(n)
    if cur==n then return end
    for k,p in pairs(pages) do
        if k==n then
            p.Visible=true
            p.Position=UDim2.new(0,5,0,0)
            TS:Create(p,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0,0)}):Play()
        else
            p.Visible=false
        end
    end
    for k,b in pairs(tabs) do
        if k==n then
            TS:Create(b,TweenInfo.new(0.22),{BackgroundColor3=EL,TextColor3=AC}):Play()
            if tabInds[k] then TS:Create(tabInds[k],TweenInfo.new(0.22),{BackgroundTransparency=0}):Play() end
        else
            TS:Create(b,TweenInfo.new(0.22),{BackgroundColor3=SF,TextColor3=MT}):Play()
            if tabInds[k] then TS:Create(tabInds[k],TweenInfo.new(0.22),{BackgroundTransparency=1}):Play() end
        end
    end
    cur=n
end
for i,n in ipairs({"Main","Play","Macro","GUI"}) do
    local b=mk("TextButton",{Size=UDim2.new(1,-16,0,28),Position=UDim2.new(0,8,0,10+(i-1)*32),BackgroundColor3=SF,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=MT,Text="  "..n,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},sideBar)
    cr(b,6)
    local ind=mk("Frame",{Size=UDim2.new(0,3,1,-16),Position=UDim2.new(0,3,0,8),BackgroundColor3=AC,BorderSizePixel=0,BackgroundTransparency=1},b)
    cr(ind,2)
    rT(ind)
    tabInds[n]=ind
    ac(b.MouseButton1Click:Connect(function() go(n) end))
    tabs[n]=b
    rT(b,function() return (cur==n) and AC or MT end,"TextColor3")
end
for i,c in ipairs({Color3.fromRGB(155,120,255),Color3.fromRGB(220,96,96),Color3.fromRGB(108,142,255),Color3.fromRGB(90,196,140),Color3.fromRGB(240,150,60),Color3.fromRGB(230,120,180),Color3.fromRGB(0,200,220),Color3.fromRGB(230,200,90)}) do
    local s=mk("TextButton",{Size=UDim2.fromOffset(12,12),Position=UDim2.new(0,8+(i-1)*13,1,-20),BackgroundColor3=c,BorderSizePixel=0,Text="",AutoButtonColor=false},sideBar)
    cr(s,6)
    ac(s.MouseButton1Click:Connect(function()
        setAC(c)
        set("acr",math.floor(c.R*255+0.5))
        set("acg",math.floor(c.G*255+0.5))
        set("acb",math.floor(c.B*255+0.5))
        if _syncThemeUI then _syncThemeUI() end
    end))
end
local function pg(n)
    local s=mk("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=EL,CanvasSize=UDim2.new(0,0,0,900),Visible=false},ct)
    pages[n]=s
    return s
end
local function cd(p,t,y)
    local f=mk("Frame",{Size=UDim2.new(1,-24,0,0),Position=UDim2.new(0,12,0,y),BackgroundColor3=PN,BorderSizePixel=0},p)
    cr(f,8)
    sk(f,BR,0.4)
    if t then
        local d=mk("Frame",{Size=UDim2.fromOffset(5,5),Position=UDim2.new(0,10,0,14),BackgroundColor3=AC,BorderSizePixel=0},f)
        cr(d,2)
        rT(d)
        local tLbl=lb(f,string.upper(t),20,10,200,12,AC,10,true)
        rT(tLbl,nil,"TextColor3")
    end
    return f
end
local function btn(p,t,x,y,w,h,k,cb)
    local o=mk("TextButton",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,Text=t,AutoButtonColor=false},p)
    if k=="p" then o.BackgroundColor3=AC o.TextColor3=Color3.new(1,1,1)
    elseif k=="d" then o.BackgroundColor3=Color3.fromRGB(56,34,34) o.TextColor3=Color3.fromRGB(230,150,150)
    else o.BackgroundColor3=EL o.TextColor3=TX end
    cr(o,6)
    if k=="p" then rT(o) end
    ac(o.MouseEnter:Connect(function()
        TS:Create(o,TweenInfo.new(0.14),{BackgroundColor3=o.BackgroundColor3:Lerp(Color3.new(1,1,1),0.15)}):Play()
    end))
    ac(o.MouseLeave:Connect(function()
        local target=EL
        if k=="p" then target=AC end
        if k=="d" then target=Color3.fromRGB(56,34,34) end
        TS:Create(o,TweenInfo.new(0.14),{BackgroundColor3=target}):Play()
    end))
    if cb then ac(o.MouseButton1Click:Connect(cb)) end
    return o
end
local function tg(p,nm,ds,x,y,w,h,on,cb)
    local box=mk("Frame",{Size=UDim2.new(0,w,0,h),Position=UDim2.new(0,x,0,y),BackgroundColor3=EL,BorderSizePixel=0},p)
    cr(box,6)
    if ds then
        lb(box,nm,10,5,w-50,14,TX,11,false)
        lb(box,ds,10,20,w-50,11,SB,9,false)
    else
        lb(box,nm,10,0,w-50,h,TX,11,false)
    end
    local st=on
    local sw=mk("Frame",{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-44,0.5,-9),BackgroundColor3=on and AC or OFF,BorderSizePixel=0},box)
    cr(sw,9)
    local kn=mk("Frame",{Size=UDim2.fromOffset(12,12),Position=on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},sw)
    cr(kn,6)
    rT(sw,function() return st and AC or OFF end)
    local function apply(v)
        st=v
        TS:Create(sw,TweenInfo.new(0.22,Enum.EasingStyle.Quart),{BackgroundColor3=v and AC or OFF}):Play()
        TS:Create(kn,TweenInfo.new(0.22,Enum.EasingStyle.Quart),{Position=v and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)}):Play()
    end
    local z=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",AutoButtonColor=false},box)
    ac(z.MouseButton1Click:Connect(function()
        apply(not st)
        if cb then cb(st) end
    end))
    return {GetValue=function() return st end,SetValue=function(v) apply(v) end}
end
local function N(title,content)
    local nf=mk("Frame",{Size=UDim2.fromOffset(220,50),Position=UDim2.new(1,-230,1,-70),BackgroundColor3=PN,BorderSizePixel=0,ZIndex=50},sg)
    cr(nf,8)
    local ns=sk(nf,AC,0.3)
    local t1=lb(nf,title,12,8,180,16,AC,11,true)
    t1.ZIndex=51
    local t2=lb(nf,content,12,26,196,18,SB,10,false)
    t2.ZIndex=51
    nf.BackgroundTransparency=1
    ns.Transparency=1
    TS:Create(nf,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play()
    TS:Create(ns,TweenInfo.new(0.2),{Transparency=0.3}):Play()
    task.delay(3,function()
        TS:Create(nf,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        TS:Create(ns,TweenInfo.new(0.3),{Transparency=1}):Play()
        TS:Create(t1,TweenInfo.new(0.3),{TextTransparency=1}):Play()
        TS:Create(t2,TweenInfo.new(0.3),{TextTransparency=1}):Play()
        task.delay(0.35,function() pcall(function() nf:Destroy() end) end)
    end)
end
local stBar=mk("Frame",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,1,-18),BackgroundColor3=SF,BorderSizePixel=0},win)
local stDot=mk("Frame",{Size=UDim2.fromOffset(5,5),Position=UDim2.new(0,11,0.5,-2),BackgroundColor3=AC,BorderSizePixel=0},stBar)
cr(stDot,3)
rT(stDot)
local stLbl=lb(stBar,"Lobby 0 | Place 0 | Upgrade 0 | Sell 0",22,0,300,18,MT,9,false)
local visWin=true
local fl=mk("TextButton",{Size=UDim2.fromOffset(78,34),Position=UDim2.new(0,16,0,16),BackgroundColor3=HD,BorderSizePixel=0,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=TX,Text="Toggle",AutoButtonColor=false,ZIndex=30},sg)
cr(fl,17)
local fS=sk(fl,AC,0.4)
rT(fS,nil,"Color")
local fd=mk("Frame",{Size=UDim2.fromOffset(8,8),Position=UDim2.new(0,10,0.5,-4),BackgroundColor3=AC,BorderSizePixel=0},fl)
cr(fd,4)
rT(fd)
local fDg,fM,f0,f1=false,false,nil,nil
ac(fl.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        fDg=true fM=false f0=i.Position f1=fl.Position
    end
end))
ac(UIS.InputChanged:Connect(function(i)
    if fDg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-f0
        if math.abs(d.X)>4 or math.abs(d.Y)>4 then fM=true end
        fl.Position=UDim2.new(f1.X.Scale,f1.X.Offset+d.X,f1.Y.Scale,f1.Y.Offset+d.Y)
    end
end))
ac(UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fDg=false end
end))
local function showWin(v)
    visWin=v
    if v then
        win.Visible=true
        win.BackgroundTransparency=1
        wS.Transparency=1
        TS:Create(win,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()
        TS:Create(wS,TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Transparency=0.35}):Play()
        TS:Create(fd,TweenInfo.new(0.24),{BackgroundColor3=AC}):Play()
    else
        TS:Create(win,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play()
        TS:Create(wS,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Transparency=1}):Play()
        task.delay(0.3,function() if not visWin then win.Visible=false end end)
        TS:Create(fd,TweenInfo.new(0.24),{BackgroundColor3=Color3.fromRGB(90,196,140)}):Play()
    end
end
ac(fl.MouseButton1Click:Connect(function() if not fM then showWin(not visWin) end end))
local scrD,dlg
local function killD(instant)
    if not dlg then return end
    if instant then
        pcall(function() dlg:Destroy() end)
        pcall(function() scrD:Destroy() end)
        dlg=nil scrD=nil return
    end
    local ti=TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
    local items={dlg,scrD}
    for _,c in ipairs(dlg:GetDescendants()) do items[#items+1]=c end
    for _,el in ipairs(items) do
        if el and el:IsA("TextLabel") then TS:Create(el,ti,{TextTransparency=1}):Play()
        elseif el and el:IsA("TextButton") then TS:Create(el,ti,{BackgroundTransparency=1,TextTransparency=1}):Play()
        elseif el and el:IsA("UIStroke") then TS:Create(el,ti,{Transparency=1}):Play()
        elseif el and el:IsA("Frame") then TS:Create(el,ti,{BackgroundTransparency=1}):Play() end
    end
    task.delay(0.28,function()
        pcall(function() dlg:Destroy() end)
        pcall(function() scrD:Destroy() end)
        dlg=nil scrD=nil
    end)
end
local function ask()
    killD(true)
    scrD=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=40},sg)
    dlg=mk("Frame",{Size=UDim2.fromOffset(280,130),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=PN,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=41},sg)
    cr(dlg,10)
    local ds=sk(dlg,BR,1)
    local dt=lb(dlg,"Close GUI",14,14,250,20,TX,14,true)
    dt.TextTransparency=1 dt.ZIndex=42
    local dm=mk("TextLabel",{Size=UDim2.new(1,-28,0,40),Position=UDim2.new(0,14,0,40),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=12,TextColor3=SB,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,Text="Are you sure you want to close this GUI?",TextTransparency=1,ZIndex=42},dlg)
    local nb=mk("TextButton",{Size=UDim2.new(0.5,-20,0,32),Position=UDim2.new(0,14,1,-46),BackgroundColor3=EL,BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=12,TextColor3=TX,TextTransparency=1,Text="No",AutoButtonColor=false,ZIndex=42},dlg)
    cr(nb,6)
    local yb=mk("TextButton",{Size=UDim2.new(0.5,-20,0,32),Position=UDim2.new(0.5,6,1,-46),BackgroundColor3=Color3.fromRGB(180,70,70),BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=12,TextColor3=Color3.new(1,1,1),TextTransparency=1,Text="Yes",AutoButtonColor=false,ZIndex=42},dlg)
    cr(yb,6)
    local ti=TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
    TS:Create(scrD,ti,{BackgroundTransparency=0.5}):Play()
    TS:Create(dlg,ti,{BackgroundTransparency=0}):Play()
    TS:Create(ds,ti,{Transparency=0.3}):Play()
    TS:Create(dt,ti,{TextTransparency=0}):Play()
    TS:Create(dm,ti,{TextTransparency=0}):Play()
    TS:Create(nb,ti,{BackgroundTransparency=0,TextTransparency=0}):Play()
    TS:Create(yb,ti,{BackgroundTransparency=0,TextTransparency=0}):Play()
    ac(nb.MouseButton1Click:Connect(function() killD(false) end))
    ac(yb.MouseButton1Click:Connect(function()
        local to=TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        local list={dlg,scrD,win,fl,wS,fS}
        for _,c in ipairs(dlg:GetDescendants()) do list[#list+1]=c end
        for _,el in ipairs(list) do
            if el and el:IsA("TextLabel") then TS:Create(el,to,{TextTransparency=1}):Play()
            elseif el and el:IsA("UIStroke") then TS:Create(el,to,{Transparency=1}):Play()
            elseif el then TS:Create(el,to,{BackgroundTransparency=1,TextTransparency=1}):Play() end
        end
        task.delay(0.35,function()
            cleanConns()
            pcall(function() sg:Destroy() end)
        end)
    end))
end
ac(xb.MouseButton1Click:Connect(ask))
local sel=Cfg.sel or ""
local C={L=0,P=0,U=0,S=0}
local rec={a={},n=1,t={},k={},l=0,active=false,lastPlaced=nil}
local R={}
local function ens(k,f,n)
    local c=R[k]
    if c and c.Parent then return c end
    local fo=RS:FindFirstChild(f)
    if not fo then return nil end
    local r=fo:FindFirstChild(n)
    if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
        R[k]=r
        return r
    end
end
local rfC=function()
    pcall(function() stLbl.Text=string.format("Lobby %d | Place %d | Upgrade %d | Sell %d",C.L,C.P,C.U,C.S) end)
end
local function visEl(d)
    if not d.Visible then return false end
    local p=d.Parent
    while p do
        if p:IsA("GuiObject") and not p.Visible then return false end
        p=p.Parent
    end
    return true
end
local function fB(tx)
    local nd=tx:lower()
    local rr={PG}
    pcall(function()
        if gethui then
            local ok,h=pcall(gethui)
            if ok and h then rr[#rr+1]=h end
        end
    end)
    for _,root in ipairs(rr) do
        if root then
            for _,d in ipairs(root:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and visEl(d) then
                    local t=d.Text
                    if d:IsA("ImageButton") then
                        local lb2=d:FindFirstChildOfClass("TextLabel")
                        if lb2 then t=lb2.Text end
                    end
                    if tostring(t or ""):lower():find(nd,1,true) then return d end
                end
            end
        end
    end
end
local _loseCache=nil
local function lose()
    if _loseCache and _loseCache.Parent and visEl(_loseCache) then return true end
    _loseCache=fB("replay")
    return _loseCache~=nil
end
local function resetRec()
    rec.a={}
    rec.n=1
    rec.t={}
    rec.k={}
    rec.l=tick()
    C.P=0
    C.U=0
    C.S=0
    rfC()
end
local macroStatusLabel,macroCountLabel
local function setStatus(s)
    if not macroStatusLabel then return end
    local col=MT
    if s=="Recording" then col=Color3.fromRGB(220,96,96)
    elseif s=="Playing" then col=Color3.fromRGB(90,196,140)
    elseif s=="Idle" then col=SB end
    macroStatusLabel.Text="Status: "..s
    TS:Create(macroStatusLabel,TweenInfo.new(0.2),{TextColor3=col}):Play()
end
local function setCount(n)
    if macroCountLabel then macroCountLabel.Text="Actions: "..tostring(n) end
end
-- Automation
local function invokeSummon(a)
    local fo=RS:FindFirstChild("RemoteFunctions")
    local ev=fo and fo:FindFirstChild("SummonUnits")
    if not ev or not ev:IsA("RemoteFunction") then return false end
    return pcall(function() ev:InvokeServer(a) end)
end
task.spawn(function()
    while true do
        if Cfg.s10 then invokeSummon(10) task.wait(1) else task.wait(0.5) end
    end
end)
task.spawn(function()
    while true do
        if Cfg.s1 then invokeSummon(1) task.wait(1) else task.wait(0.5) end
    end
end)
task.spawn(function()
    while true do
        if Cfg.spn then
            local fo=RS:FindFirstChild("RemoteFunctions")
            local ev=fo and fo:FindFirstChild("SpinWheel")
            if ev and ev:IsA("RemoteFunction") then
                pcall(function() ev:InvokeServer() end)
            end
            task.wait(0.5)
        else
            task.wait(0.2)
        end
    end
end)
task.spawn(function()
    while true do
        if Cfg.oc then
            local fo=RS:FindFirstChild("RemoteFunctions")
            local ev=fo and fo:FindFirstChild("OpenCrate")
            if ev and ev:IsA("RemoteFunction") then
                pcall(function() ev:InvokeServer(Cfg.crate or "Free",1) end)
            end
            task.wait(1)
        else
            task.wait(0.3)
        end
    end
end)
local lbLoop=false
local function startLB()
    if lbLoop then return end
    lbLoop=true
    task.spawn(function()
        while Cfg.lb do
            local tl=RS:FindFirstChild("ReturnToLobby")
            if tl and tl:IsA("RemoteEvent") then
                if pcall(function() tl:FireServer() end) then
                    C.L=C.L+1
                    rfC()
                end
            end
            task.wait(1)
        end
        lbLoop=false
    end)
end
task.spawn(function()
    local was=false
    while true do
        local now=lose()
        if now and not was and rec.active then
            resetRec()
            setCount(0)
        end
        was=now
        task.wait(1)
    end
end)
local lastW=nil
local function getSkipBtn()
    local ok,b=pcall(function() return PG.MainGameUI.UpSide.InfoDop.AutoSkip end)
    return ok and b or nil
end
local function setVis(on)
    pcall(function()
        local b=getSkipBtn()
        if not b then return end
        for _,v in ipairs(b:GetDescendants()) do
            if v:IsA("UIGradient") then
                if v.Name=="AutoOff" then v.Enabled=not on
                elseif v.Name=="AutoOn" then v.Enabled=on end
            end
        end
    end)
end
task.spawn(function()
    while true do
        if Cfg.sk then
            local ws=RS:FindFirstChild("WaveState")
            if ws then
                local w=ws:GetAttribute("CurrentWave")
                local c=ws:GetAttribute("CanSkipWave")
                local r=ws:GetAttribute("Result")
                if c==true and r~="Win" and r~="Lose" and lastW~=w then
                    lastW=w
                    local skR=ens("w","RemoteEvents","SkipWaveVote")
                    if skR then pcall(function() skR:FireServer(w) end) end
                end
            end
        end
        task.wait(0.5)
    end
end)
local rpL=false
local function startRP()
    if rpL then return end
    rpL=true
    task.spawn(function()
        while Cfg.rp do
            local re=RS:FindFirstChild("RemoteEvents")
            local rv=re and re:FindFirstChild("ReplayVote")
            if rv and pcall(function() rv:FireServer() end) then
                C.L=C.L+1
                rfC()
            end
            task.wait(1)
        end
        rpL=false
    end)
end
-- Record system
local HR={PL=nil,UP=nil,SE=nil,SK=nil,SP=nil}
local function refreshHR()
    HR.PL=ens("p","RemoteFunctions","PlaceTower")
    HR.UP=ens("u","RemoteFunctions","UpgradeTower")
    HR.SE=ens("s","RemoteFunctions","SellTower")
    HR.SK=ens("w","RemoteEvents","SkipWaveVote")
    HR.SP=ens("g","RemoteEvents","SetGameSpeed")
end
refreshHR()
task.spawn(function()
    while true do
        if rec.active then refreshHR() end
        task.wait(5)
    end
end)
local HOOK_MODE="none"
local HOOK_OK=false
do
    if type(hookmetamethod)=="function" and type(newcclosure)=="function" then
        HOOK_MODE="hookmetamethod"
    elseif type(getrawmetatable)=="function" and type(setreadonly)=="function" and type(newcclosure)=="function" then
        HOOK_MODE="getrawmetatable"
    end
end
local function findAndClaim(id,cf)
    local t0=tick()
    while tick()-t0<3 do
        local tw=workspace:FindFirstChild("Towers")
        if tw then
            local bd,b=20,nil
            for _,xx in ipairs(tw:GetChildren()) do
                if not rec.k[xx] then
                    local ok,q=pcall(function() return xx:GetPivot().Position end)
                    if ok and q then
                        local dist=(q-cf.Position).Magnitude
                        if dist<bd then b=xx bd=dist end
                    end
                end
            end
            if b and not rec.k[b] then
                rec.t[id]=b
                rec.k[b]=id
                rec.lastPlaced=b
                return b
            end
        end
        task.wait(0.05)
    end
    return nil
end
local hookHits=0
if HOOK_MODE=="hookmetamethod" then
    pcall(function()
        local old
        old=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
            if not rec.active then return old(self,...) end
            if self~=HR.PL and self~=HR.UP and self~=HR.SE and self~=HR.SK and self~=HR.SP then
                return old(self,...)
            end
            local m=getnamecallmethod and getnamecallmethod() or ""
            local args={...}
            local r=old(self,...)
            hookHits=hookHits+1
            if m=="InvokeServer" and self==HR.PL then
                local n,cf=args[1],args[2]
                if typeof(cf)=="CFrame" then
                    C.P=C.P+1
                    local id=rec.n rec.n=id+1
                    local tk=tick()
                    rec.a[#rec.a+1]={t="P",n=n,p={cf.Position.X,cf.Position.Y,cf.Position.Z},i=id,d=tk-(rec.l or tk)}
                    rec.l=tk
                    task.spawn(function() findAndClaim(id,cf) rfC() setCount(#rec.a) end)
                end
            elseif m=="InvokeServer" and self==HR.UP then
                local id=rec.k[args[1]]
                if id then
                    C.U=C.U+1
                    local tk=tick()
                    rec.a[#rec.a+1]={t="U",i=id,d=tk-(rec.l or tk)}
                    rec.l=tk
                    rfC() setCount(#rec.a)
                end
            elseif m=="InvokeServer" and self==HR.SE then
                local inst,id=args[1],rec.k[args[1]]
                if id then
                    C.S=C.S+1
                    local tk=tick()
                    rec.a[#rec.a+1]={t="S",i=id,d=tk-(rec.l or tk)}
                    rec.l=tk
                    rec.t[id]=nil rec.k[inst]=nil
                    rfC() setCount(#rec.a)
                end
            elseif m=="FireServer" and self==HR.SK then
                local tk=tick()
                rec.a[#rec.a+1]={t="W",d=tk-(rec.l or tk)}
                rec.l=tk setCount(#rec.a)
            elseif m=="FireServer" and self==HR.SP then
                local tk=tick()
                rec.a[#rec.a+1]={t="G",v=args[1],d=tk-(rec.l or tk)}
                rec.l=tk setCount(#rec.a)
            end
            return r
        end))
        HOOK_OK=true
    end)
elseif HOOK_MODE=="getrawmetatable" then
    pcall(function()
        local mt=getrawmetatable(game)
        local old=mt.__namecall
        setreadonly(mt,false)
        mt.__namecall=newcclosure(function(self,...)
            if not rec.active then return old(self,...) end
            if self~=HR.PL and self~=HR.UP and self~=HR.SE and self~=HR.SK and self~=HR.SP then
                return old(self,...)
            end
            local m=getnamecallmethod and getnamecallmethod() or ""
            local args={...}
            local r=old(self,...)
            hookHits=hookHits+1
            if m=="InvokeServer" and self==HR.PL then
                local n,cf=args[1],args[2]
                if typeof(cf)=="CFrame" then
                    C.P=C.P+1
                    local id=rec.n rec.n=id+1
                    local tk=tick()
                    rec.a[#rec.a+1]={t="P",n=n,p={cf.Position.X,cf.Position.Y,cf.Position.Z},i=id,d=tk-(rec.l or tk)}
                    rec.l=tk
                    task.spawn(function() findAndClaim(id,cf) rfC() setCount(#rec.a) end)
                end
            elseif m=="InvokeServer" and self==HR.UP then
                local id=rec.k[args[1]]
                if id then
                    C.U=C.U+1
                    local tk=tick()
                    rec.a[#rec.a+1]={t="U",i=id,d=tk-(rec.l or tk)}
                    rec.l=tk
                    rfC() setCount(#rec.a)
                end
            elseif m=="InvokeServer" and self==HR.SE then
                local inst,id=args[1],rec.k[args[1]]
                if id then
                    C.S=C.S+1
                    local tk=tick()
                    rec.a[#rec.a+1]={t="S",i=id,d=tk-(rec.l or tk)}
                    rec.l=tk
                    rec.t[id]=nil rec.k[inst]=nil
                    rfC() setCount(#rec.a)
                end
            elseif m=="FireServer" and self==HR.SK then
                local tk=tick()
                rec.a[#rec.a+1]={t="W",d=tk-(rec.l or tk)}
                rec.l=tk setCount(#rec.a)
            elseif m=="FireServer" and self==HR.SP then
                local tk=tick()
                rec.a[#rec.a+1]={t="G",v=args[1],d=tk-(rec.l or tk)}
                rec.l=tk setCount(#rec.a)
            end
            return r
        end)
        setreadonly(mt,true)
        HOOK_OK=true
    end)
end
if HOOK_OK then
    print("[EZVC] Hook mode: "..HOOK_MODE)
else
    print("[EZVC] No hooking API - using passive mode")
end
local passiveConns={}
local knownTowers={}
local function clearPassive()
    for _,c in ipairs(passiveConns) do pcall(function() c:Disconnect() end) end
    passiveConns={}
end
local function getTowerName(t)
    for _,a in ipairs({"UnitName","TowerName","Type","Unit","UnitType","Tower"}) do
        local v=t:GetAttribute(a)
        if type(v)=="string" and v~="" then return v end
    end
    for _,c in ipairs(t:GetChildren()) do
        if c:IsA("StringValue") and (c.Name:lower():find("type") or c.Name:lower():find("name")) then
            if c.Value~="" then return c.Value end
        end
    end
    return t.Name
end
local function watchTower(tower,id)
    local a_=tower.AttributeChanged:Connect(function(attr)
        if not rec.active then return end
        local l=attr:lower()
        if l=="level" or l=="tier" or l=="upgrade" or l=="rank" or l=="upgraded" then
            C.U=C.U+1
            local tk=tick()
            rec.a[#rec.a+1]={t="U",i=id,d=tk-(rec.l or tk)}
            rec.l=tk
            rfC() setCount(#rec.a)
        end
    end)
    passiveConns[#passiveConns+1]=a_
    local dc=tower.Destroying:Connect(function()
        if not rec.active then return end
        if rec.k[tower]~=id then return end
        if lose() then return end
        C.S=C.S+1
        local tk=tick()
        rec.a[#rec.a+1]={t="S",i=id,d=tk-(rec.l or tk)}
        rec.l=tk
        rec.t[id]=nil rec.k[tower]=nil
        rfC() setCount(#rec.a)
    end)
    passiveConns[#passiveConns+1]=dc
end
local function onTowerAdded(tower)
    if not rec.active then return end
    if knownTowers[tower] then return end
    knownTowers[tower]=true
    local ok,cf=pcall(function() return tower:GetPivot() end)
    if not ok or not cf then return end
    C.P=C.P+1
    local id=rec.n rec.n=id+1
    local tk=tick()
    rec.t[id]=tower rec.k[tower]=id rec.lastPlaced=tower
    rec.a[#rec.a+1]={
        t="P",n=getTowerName(tower),
        p={cf.Position.X,cf.Position.Y,cf.Position.Z},
        i=id,d=tk-(rec.l or tk)
    }
    rec.l=tk
    rfC() setCount(#rec.a)
    watchTower(tower,id)
end
local function attachPassive()
    local tw=workspace:FindFirstChild("Towers")
    if tw then
        for _,t in ipairs(tw:GetChildren()) do knownTowers[t]=true end
        passiveConns[#passiveConns+1]=tw.ChildAdded:Connect(onTowerAdded)
    else
        local wc
        wc=workspace.ChildAdded:Connect(function(child)
            if child.Name=="Towers" then
                if wc then wc:Disconnect() end
                for _,t in ipairs(child:GetChildren()) do knownTowers[t]=true end
                passiveConns[#passiveConns+1]=child.ChildAdded:Connect(onTowerAdded)
            end
        end)
        passiveConns[#passiveConns+1]=wc
    end
end
local function startPassive()
    knownTowers={}
    clearPassive()
    attachPassive()
end
-- Playback with stat tracking
task.spawn(function()
    local function nf(pos,ctx)
        local tw=workspace:FindFirstChild("Towers")
        if not tw then return nil end
        local bd,b=20,nil
        for _,x in ipairs(tw:GetChildren()) do
            if not ctx.k[x] then
                local ok,q=pcall(function() return x:GetPivot().Position end)
                if ok and q then
                    local d=(q-pos).Magnitude
                    if d<bd then b=x bd=d end
                end
            end
        end
        return b
    end
    while true do
        if Cfg.pl and Cfg.sel~="" then
            local data=loadMacro(Cfg.sel)
            if data and #data>0 then
                C.P=0 C.U=0 C.S=0 rfC()
                local P2={t={},k={},i=1}
                while Cfg.pl and P2.i<=#data do
                    local a=data[P2.i]
                    if a then
                        if (a.d or 0)>0 then task.wait(a.d) end
                        if not Cfg.pl then break end
                        if a.t=="P" then
                            local PL=ens("p","RemoteFunctions","PlaceTower")
                            if PL then
                                local cf=CFrame.new(a.p[1],a.p[2],a.p[3])
                                pcall(function() PL:InvokeServer(a.n,cf) end)
                                C.P=C.P+1 rfC()
                                local t0=tick()
                                while tick()-t0<2 do
                                    local inst=nf(cf.Position,P2)
                                    if inst then P2.t[a.i]=inst P2.k[inst]=a.i break end
                                    task.wait(0.05)
                                end
                            end
                        elseif a.t=="U" then
                            local UP=ens("u","RemoteFunctions","UpgradeTower")
                            local inst=P2.t[a.i]
                            if UP and inst and inst.Parent then
                                pcall(function() UP:InvokeServer(inst) end)
                                C.U=C.U+1 rfC()
                            end
                        elseif a.t=="S" then
                            local SE=ens("s","RemoteFunctions","SellTower")
                            local inst=P2.t[a.i]
                            if SE and inst and inst.Parent then
                                pcall(function() SE:InvokeServer(inst) end)
                                C.S=C.S+1 rfC()
                                P2.t[a.i]=nil
                                P2.k[inst]=nil
                            end
                        elseif a.t=="W" then
                            local SK=ens("w","RemoteEvents","SkipWaveVote")
                            if SK then pcall(function() SK:FireServer(1) end) end
                        elseif a.t=="G" then
                            local SP=ens("g","RemoteEvents","SetGameSpeed")
                            if SP then pcall(function() SP:FireServer(a.v) end) end
                        end
                    end
                    P2.i=P2.i+1
                end
                if Cfg.pl then task.wait(2) end
            else
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end)
-- ============================================================
-- MAIN PAGE
-- ============================================================
local mP=pg("Main")
local c2=cd(mP,"Automation",12)
c2.Size=UDim2.new(1,-24,0,250)
local s10T,s1T
s10T=tg(c2,"Auto Summon 10","Summon 10 units/s",12,26,240,38,Cfg.s10,function(on)
    set("s10",on)
    if on and s1T then s1T.SetValue(false) set("s1",false) end
end)
s1T=tg(c2,"Auto Summon 1","Summon 1 unit/s",12,70,240,38,Cfg.s1,function(on)
    set("s1",on)
    if on and s10T then s10T.SetValue(false) set("s10",false) end
end)
tg(c2,"Auto Spin","Spin wheel automatically",12,114,240,38,Cfg.spn,function(on) set("spn",on) end)
tg(c2,"Auto Open Crate","Open selected crate/s",12,158,240,38,Cfg.oc,function(on) set("oc",on) end)
local crateOpts={"Free","ScientistCrate","PartyCrate"}
local crateIdx=1
for i,v in ipairs(crateOpts) do if v==Cfg.crate then crateIdx=i end end
local crateLbl=mk("TextButton",{Size=UDim2.new(1,-24,0,26),Position=UDim2.new(0,12,0,202),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text="Crate: "..(Cfg.crate or "Free"),AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},c2)
cr(crateLbl,5)
ac(crateLbl.MouseButton1Click:Connect(function()
    crateIdx=crateIdx%#crateOpts+1
    Cfg.crate=crateOpts[crateIdx]
    set("crate",Cfg.crate)
    crateLbl.Text="Crate: "..Cfg.crate
    N("EZVC","Crate: "..Cfg.crate)
end))
-- ============================================================
-- PLAY PAGE
-- ============================================================
local pP=pg("Play")
local pc=cd(pP,"Game Speed",12)
pc.Size=UDim2.new(1,-24,0,60)
lb(pc,"Speed",12,28,60,24,SB,11,false)
local gsOpts={"1","1.50","2"}
local gsCur=Cfg.gs or "1"
local gsIdx=1
for i,v in ipairs(gsOpts) do if v==gsCur then gsIdx=i end end
local gsLbl=mk("TextButton",{Size=UDim2.new(0,120,0,28),Position=UDim2.new(1,-132,0,22),BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=gsCur,AutoButtonColor=false},pc)
cr(gsLbl,5)
ac(gsLbl.MouseButton1Click:Connect(function()
    gsIdx=gsIdx%#gsOpts+1
    gsCur=gsOpts[gsIdx]
    gsLbl.Text=gsCur
    set("gs",gsCur)
    local n=tonumber(gsCur)
    if n then
        local g=ens("g","RemoteEvents","SetGameSpeed")
        if g then pcall(function() g:FireServer(n) end) end
    end
end))
local pc2=cd(pP,"Toggles",80)
pc2.Size=UDim2.new(1,-24,0,170)
tg(pc2,"Auto Skip Wave","Skip waves automatically",12,26,240,38,Cfg.sk,function(on)
    set("sk",on)
    if on then lastW=nil setVis(true) else setVis(false) end
end)
tg(pc2,"Auto Replay","Vote replay on round end",12,70,240,38,Cfg.rp,function(on)
    set("rp",on)
    if on then startRP() else rpL=false end
end)
tg(pc2,"Auto Lobby","Return to lobby automatically",12,114,240,38,Cfg.lb,function(on)
    set("lb",on)
    if on then startLB() else lbLoop=false end
end)
-- ============================================================
-- MACRO PAGE
-- ============================================================
local mP2=pg("Macro")
local rc=cd(mP2,"Macro Name",12)
rc.Size=UDim2.new(1,-24,0,56)
lb(rc,"Name",12,26,50,24,SB,11,false)
local mnBox=mk("TextBox",{Size=UDim2.new(1,-80,0,26),Position=UDim2.new(0,64,0,20),BackgroundColor3=BG,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,PlaceholderText="e.g. EasyFarm",PlaceholderColor3=MT,Text=Cfg.mn or "",ClearTextOnFocus=false},rc)
cr(mnBox,5)
ac(mnBox.FocusLost:Connect(function() set("mn",mnBox.Text or "") end))
local rc2=cd(mP2,"Macro Actions",76)
rc2.Size=UDim2.new(1,-24,0,320)
macroStatusLabel=lb(rc2,"Status: Idle",12,26,110,14,SB,10,true)
macroCountLabel=lb(rc2,"Actions: 0",124,26,100,14,MT,10,false)
-- Statistics sub-section (fixed Place/Upgrade/Sell/Lobby counters)
lb(rc2,"STATISTICS",12,48,120,12,SB,9,true)
local statLobby=lb(rc2,"Lobby: 0",12,64,120,16,TX,11,true)
local statPlace=lb(rc2,"Place: 0",132,64,120,16,TX,11,true)
local statUpgrade=lb(rc2,"Upgrade: 0",12,84,120,16,TX,11,true)
local statSell=lb(rc2,"Sell: 0",132,84,120,16,TX,11,true)
local _prevRfC2=rfC
rfC=function()
    _prevRfC2()
    pcall(function()
        statLobby.Text="Lobby: "..tostring(C.L)
        statPlace.Text="Place: "..tostring(C.P)
        statUpgrade.Text="Upgrade: "..tostring(C.U)
        statSell.Text="Sell: "..tostring(C.S)
    end)
end
local macroList=lf()
local macroIdx=0
for i,v in ipairs(macroList) do if v==Cfg.sel then macroIdx=i end end
local macroLbl=mk("TextButton",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,108),BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text=Cfg.sel~="" and Cfg.sel or "-- select macro --",AutoButtonColor=false},rc2)
cr(macroLbl,5)
local function refreshMacroLbl()
    macroList=lf()
    macroIdx=0
    for i,v in ipairs(macroList) do if v==Cfg.sel then macroIdx=i end end
    macroLbl.Text=Cfg.sel~="" and Cfg.sel or "-- select macro --"
end
ac(macroLbl.MouseButton1Click:Connect(function()
    macroList=lf()
    if #macroList==0 then N("EZVC","No saved macros") return end
    macroIdx=macroIdx%#macroList+1
    local chosen=macroList[macroIdx]
    macroLbl.Text=chosen
    sel=chosen
    set("sel",chosen)
end))
btn(rc2,"Create / Save Macro",12,144,240,28,"p",function()
    local n=mnBox.Text or ""
    if n=="" then N("EZVC","Enter a macro name") return end
    pcall(function()
        if type(isfile)~="function" or not isfile(FO..n..".json") then
            wj(FO..n..".json",{})
        end
    end)
    sel=n
    set("sel",n)
    refreshMacroLbl()
    N("EZVC","Macro ready: "..n)
end)
local rToggle
rToggle=tg(rc2,"Record Macro","Start/stop recording",12,180,240,38,Cfg.rec,function(on)
    if on then
        if rec.active then N("EZVC","Already recording") rToggle.SetValue(true) return end
        if Cfg.pl then N("EZVC","Stop playback first") rToggle.SetValue(false) return end
        if Cfg.sel=="" then N("EZVC","Select a macro first") rToggle.SetValue(false) return end
        set("rec",true)
        refreshHR()
        resetRec()
        setCount(0)
        hookHits=0
        rec.active=true
        setStatus("Recording")
        if not HOOK_OK then startPassive() end
        N("EZVC","Recording -> "..Cfg.sel..(HOOK_OK and "" or " (passive)"))
    else
        if not rec.active then set("rec",false) setStatus("Idle") return end
        rec.active=false
        set("rec",false)
        if not HOOK_OK then clearPassive() end
        if #rec.a>0 and Cfg.sel~="" then
            if wj(FO..Cfg.sel..".json",rec.a) then
                N("EZVC","Saved "..#rec.a.." steps")
            else
                N("EZVC","Save failed")
            end
        else
            local diag
            if HOOK_OK then
                diag="hook="..HOOK_MODE.." hits="..hookHits
            else
                diag="passive, no towers detected"
            end
            N("EZVC","Nothing saved ("..diag..")")
            warn("[EZVC] "..diag)
        end
        resetRec()
        setCount(0)
        setStatus("Idle")
    end
end)
local pToggle
pToggle=tg(rc2,"Play Macro","Playback recorded macro",12,224,240,38,Cfg.pl,function(on)
    if on then
        if rec.active then N("EZVC","Stop recording first") pToggle.SetValue(false) return end
        if Cfg.sel=="" then N("EZVC","Select a macro first") pToggle.SetValue(false) return end
        set("pl",true)
        setStatus("Playing")
    else
        set("pl",false)
        setStatus("Idle")
    end
end)
btn(rc2,"Delete Macro",12,270,240,28,"d",function()
    if Cfg.sel=="" then N("EZVC","Select a macro") return end
    pcall(function()
        if type(delfile)=="function" then delfile(FO..Cfg.sel..".json") end
    end)
    sel=""
    set("sel","")
    refreshMacroLbl()
    N("EZVC","Deleted")
end)
-- ============================================================
-- GUI PAGE
-- ============================================================
local gP=pg("GUI")
local th=cd(gP,"Theme",12)
th.Size=UDim2.new(1,-24,0,180)
local themes={
    {n="Purple",c=Color3.fromRGB(155,120,255)},
    {n="Red",   c=Color3.fromRGB(220,96,96)},
    {n="Blue",  c=Color3.fromRGB(108,142,255)},
    {n="Green", c=Color3.fromRGB(90,196,140)},
    {n="Orange",c=Color3.fromRGB(240,150,60)},
    {n="Pink",  c=Color3.fromRGB(230,120,180)},
    {n="Cyan",  c=Color3.fromRGB(0,200,220)},
    {n="Yellow",c=Color3.fromRGB(230,200,90)},
}
local themeEntries={}
local function isSame(a,b)
    return math.abs(a.R-b.R)<0.01 and math.abs(a.G-b.G)<0.01 and math.abs(a.B-b.B)<0.01
end
local function syncThemeSel()
    for _,e in ipairs(themeEntries) do
        local isSel=isSame(e.c,AC)
        TS:Create(e.str,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{Transparency=isSel and 0 or 0.85,Color=e.c}):Play()
    end
end
_syncThemeUI=syncThemeSel
for i,t in ipairs(themes) do
    local col=(i-1)%2
    local row=math.floor((i-1)/2)
    local px=(col==0) and UDim2.new(0,12,0,30+row*34) or UDim2.new(0.5,6,0,30+row*34)
    local b=mk("TextButton",{Size=UDim2.new(0.5,-18,0,28),Position=px,BackgroundColor3=EL,BorderSizePixel=0,Font=Enum.Font.Gotham,TextSize=11,TextColor3=TX,Text="  "..t.n,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left},th)
    cr(b,6)
    local str=sk(b,t.c,0.85)
    local dot=mk("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.new(1,-22,0.5,-7),BackgroundColor3=t.c,BorderSizePixel=0},b)
    cr(dot,7)
    themeEntries[#themeEntries+1]={btn=b,str=str,c=t.c}
end
for _,e in ipairs(themeEntries) do
    ac(e.btn.MouseButton1Click:Connect(function()
        setAC(e.c)
        set("acr",math.floor(e.c.R*255+0.5))
        set("acg",math.floor(e.c.G*255+0.5))
        set("acb",math.floor(e.c.B*255+0.5))
        syncThemeSel()
    end))
end
syncThemeSel()
local ut=cd(gP,"Utility",204)
ut.Size=UDim2.new(1,-24,0,70)
local afkConn=nil
local function applyAFK(on)
    if afkConn then pcall(function() afkConn:Disconnect() end) afkConn=nil end
    if on then
        afkConn=PLR.Idled:Connect(function()
            pcall(function()
                VU:CaptureController()
                VU:ClickButton2(Vector2.new())
            end)
        end)
    end
end
tg(ut,"Anti AFK","Prevents idle kick",12,26,240,38,Cfg.afk,function(on)
    set("afk",on)
    applyAFK(on)
end)
-- ============================================================
-- POST-LOAD
-- ============================================================
_init=false
task.spawn(function()
    task.wait(1.5)
    instantApply()
    syncThemeSel()
    local gs=tonumber(Cfg.gs)
    if gs then
        local g=ens("g","RemoteEvents","SetGameSpeed")
        if g then pcall(function() g:FireServer(gs) end) end
    end
    if Cfg.sk then lastW=nil setVis(true) end
    if Cfg.rp then startRP() end
    if Cfg.lb then startLB() end
    if Cfg.afk then applyAFK(true) end
    if Cfg.rec and Cfg.sel~="" then
        refreshHR()
        resetRec()
        setCount(0)
        hookHits=0
        rec.active=true
        setStatus("Recording")
        if not HOOK_OK then startPassive() end
        rToggle.SetValue(true)
    elseif Cfg.rec then
        Cfg.rec=false
        save()
        setStatus("Idle")
        rToggle.SetValue(false)
    end
    if Cfg.pl and Cfg.sel=="" then
        Cfg.pl=false
        save()
        pToggle.SetValue(false)
    elseif Cfg.pl then
        setStatus("Playing")
    end
end)
go("Main")
rfC()
N("EZVC","Ready v2.1")
print("[EZVC] v2.1 loaded | mode="..(HOOK_OK and HOOK_MODE or "passive"))