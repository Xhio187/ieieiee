local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  } 
  
  
  ESX                           = nil
  local norg = 'brak'
  local ngrade = nil
  local akcja = nil
  local blipss = {}
  local czymozna = false
  Citizen.CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		  Citizen.Wait(0)
      end
      
      Citizen.Wait(15000)
      while ngrade == nil do
        Citizen.Wait(1000)
      ESX.TriggerServerCallback('w_organizacje:get', function(org, grade)
        norg = org
        ngrade = grade
      end)
      Citizen.Wait(5000)
    end
      Citizen.Wait(5000)
      TriggerEvent('w_organizacje:bliporg')
  
  end)

  RegisterNetEvent('w_organizacje:ustawprace')
  AddEventHandler('w_organizacje:ustawprace', function(job, grade)
   norg = job
    ngrade = grade
    TriggerEvent('w_organizacje:bliporg')
  end)

local ped 
local playerPos 


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
       ped = GetPlayerPed(-1)
       playerPos = GetEntityCoords(ped)
       Citizen.Wait(500)
    end
end)


function msg(text)
  TriggerEvent('chat:addMessage', {
    template = '<div style="padding: 0.1vw; margin: 0.1vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;"><i class="fa fa-exclamation-triangle"></i> {0}: {1}</div>',
    args = { "ORGANIZACJE", text }
})
end



RegisterNetEvent('w_organizacje:restart')
  AddEventHandler('w_organizacje:restart', function()
    ESX.TriggerServerCallback('w_organizacje:get', function(org, grade)
    
      norg = org
      ngrade = grade
      TriggerEvent('w_organizacje:bliporg')
    end)
  end)



RegisterNetEvent('w_organizacje:bliporg')
  AddEventHandler('w_organizacje:bliporg', function(job)
    for k, usun in pairs(blipss) do
      RemoveBlip(usun)
    end
    ESX.TriggerServerCallback('w_organizacje:get', function(org, grade)
      
      norg = org
      ngrade = grade
    end)

    Citizen.Wait(5000)
 
    if Config[norg] ~= nil then
     czymozna =  true
      blipb = AddBlipForCoord(Config[norg].Blip.x,  Config[norg].Blip.y,  Config[norg].Blip.z)
      SetBlipSprite (blipb, 411)
      SetBlipDisplay(blipb, 4)
      SetBlipScale  (blipb, 0.7)
      SetBlipColour (blipb, 75)
      SetBlipAsShortRange(blipb, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("Organizacja: "..norg)
      EndTextCommandSetBlipName(blipb)
      table.insert(blipss, blipb)
    end
  end)




function wezitem()
    ESX.TriggerServerCallback('w_organizacje:wezitem', function(callback_tabka)
      local elements = {} 
      --elements = callback_tabka
      table.insert( elements, {label = 'xD'} )
    ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'menuname', 
    {
      title    = ('Weź item'),
      align = 'center', 
      elements = elements
    },
    function(data, menu) 
      menu.close() 
  
      TriggerServerEvent('w_sklepsystem:wezitem', norg, data.current.value, data.current.item)
    end,
    function(data, menu) 
        menu.close() 
    end)
  end, norg, ngrade)
  end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if norg ~= 'brak' and norg ~= 'unemployed' and czymozna then
	for _,v in pairs(Config[norg].Ciuchy) do
		if (Vdist(playerPos.x, playerPos.y, playerPos.z, v.x, v.y, v.z) < 5.0) then
      DrawMarker(6, v.x, v.y, v.z-0.05, 0.0, 0.0, 0.0, 90.0, 90.0, 90.0, 1.0, 1.0, 1.0, 255,0,0, 100, false, true, 2, false, false, false, false)
            akcja = "Ciuchy"
		end
    end

    for _,v in pairs(Config[norg].Szafka) do
		if (Vdist(playerPos.x, playerPos.y, playerPos.z, v.x, v.y, v.z) < 2.0) then
            DrawMarker(6, v.x, v.y, v.z-0.05, 0.0, 0.0, 0.0, 90.0, 90.0, 90.0, 1.0, 1.0, 1.0, 255,0,0, 100, false, true, 2, false, false, false, false)
            akcja = Config[norg].Szafka
		end
    end

    for _,v in pairs(Config[norg].Szef) do
		if (Vdist(playerPos.x, playerPos.y, playerPos.z, v.x, v.y, v.z) < 2.0) then
      DrawMarker(6, v.x, v.y, v.z-0.05, 0.0, 0.0, 0.0, 90.0, 90.0, 90.0, 1.0, 1.0, 1.0, 255,0,0, 100, false, true, 2, false, false, false, false)
            akcja = Config[norg].Szef
		end
    end

else
    Citizen.Wait(5000)
end


end
end)



Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1)
       
        if akcja ~= nil then
        for _,v in pairs(akcja) do
            if (Vdist(playerPos.x, playerPos.y, playerPos.z, v.x, v.y, v.z) < 2.0) then
                if IsControlJustPressed(0, Keys['E']) then
                    if akcja == Config[norg].Szafka then
                        szafka()
                    elseif akcja == Config[norg].Szef then
                      szefmenu()
                    end
                end
            end
        end
    else
        Citizen.Wait(1000)
    end
end
end)


function szafka()
    local elements = {}
    ESX.TriggerServerCallback('w_organizacje:getpermisje', function(permisje)
      
      if tonumber(permisje['wezitem']) == 1 then
        table.insert( elements, {label = "Weź item", value = 'wezitem'} )
      end
      if permisje['wrzucitem'] == 1 then
        table.insert( elements, {label = "Wrzuć item", value = 'wrzucitem'} )
      end
     -- table.insert( elements, {label = "==================="})
     -- if permisje['wezbron'] == 1 then
        --table.insert( elements, {label = "Weź broń", value = 'wezbron'} )
     -- end
     -- if permisje['wrzucbron'] == 1 then
       -- table.insert( elements, {label = "Wrzuć broń", value = 'wrzucbron'} )
     -- end

      
    

    ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'menuname', 
    {
      title    = ('Szafka '..norg),
      align = 'center', 
      elements = elements
    },
    function(data, menu) 
    
      if data.current.value == 'wezitem' then
        menu.close() 
        wezitem()
      elseif data.current.value == 'wezbron' then
        menu.close()
        wezbron()
      elseif data.current.value == 'wrzucitem' then
        menu.close() 
        odlozitem()
      elseif data.current.value == "wrzucbron" then
        menu.close()
        odlozbron()
      end   
    end,
    function(data, menu) 
        menu.close()
    end
  )
end, norg, ngrade)
end







function szefmenu()
  
  local elements = {}
  if tonumber(ngrade) >= 4 then
    table.insert( elements, {label = "Permisje", value = 'permisjea'})
    table.insert( elements, {label = "Zarządzanie członkami", value = 'pracownicy'})
    end
  ESX.TriggerServerCallback('w_organizacje:getpermisje', function(permisje)

    if permisje['stankonta'] == 1 then
      ESX.TriggerServerCallback('w_organizacje:getkonto', function(sianko)
      table.insert( elements, {label = "Stan konta: <font color='green'>"..sianko.."$</font>", value = nil} )
      end, norg, "zwykle")
    end
    Citizen.Wait(500)
    if permisje['wrzucpieniadze'] == 1 then
      table.insert( elements, {label = "Wpłać pieniądze na konto", value = 'wrzucpieniadze'} )
    end
    if permisje['wyplac'] == 1 then
      table.insert( elements, {label = "Wypłać pieniądze z konta", value = 'wyplac'} )
    end
    if permisje['zapros'] == 1 then
      table.insert( elements, {label = "Dodaj do organizacji", value = 'zapros'} )
    end
  ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'szefmenus', 
  {
    title    = ('Zarządzanie '..norg),
    align = 'center', 
    elements = elements
  },
  function(data, menu) 
  

    if data.current.value == 'wrzucpieniadze' then
      menu.close()
      wplac("N")
    elseif data.current.value == 'wyplac' then
      menu.close()
      wyplac("N")
    elseif data.current.value == 'zapros' then
      menu.close()
      zapros()
    elseif data.current.value == 'permisjea' then
      menu.close()
      permisjea()
    elseif data.current.value == "pracownicy" then
      menu.close()
      pracownicy()
    end   
  end,
  function(data, menu) 
      menu.close()
  end
)
end, norg, ngrade)
end









function permisje(gradee)
  local elements = {}
  local elem = {}
    

      table.insert( elements, {label = "Wyciąganie itemu | Dostęp: ", value = 'wezitem'} )
      table.insert( elements, {label = "Wrzucanie itemów | Dostęp: ", value = 'wrzucitem'} )
      table.insert( elements, {label = "Wyciąganie broni | Dostęp: ", value = 'wezbron'} )
      table.insert( elements, {label = "Wyrzucanie broni | Dostęp: ", value = 'wrzucbron'} )
      table.insert( elements, {label = "Stan konta | Dostęp: ", value = 'stankonta'} )
      table.insert( elements, {label = "Wpłacanie | Dostęp: ", value = 'wrzucpieniadze'} )
      table.insert( elements, {label = "Wypłacanie | Dostęp: ", value = 'wyplac'} )
      table.insert( elements, {label = "Zapraszanie do org | Dostęp: ", value = 'zapros'} )

      ESX.TriggerServerCallback('w_organizacje:getpermisje', function(permisje)
    for _,v in pairs(elements) do
      local what = 'NIE'
      if tonumber(permisje[v.value]) == 1 then
        what = 'TAK'
      end
        table.insert( elem, {label =  v.label..what, value = v.value})
    end
  end, norg, gradee)
  Citizen.Wait(500)


  ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'menuname', 
  {
    title    = ('Menu Szefa '..norg),
    align = 'center', 
    elements = elem
  },
  function(data, menu) 
    TriggerServerEvent('w_organizacje:zmianapermisji', norg, gradee, data.current.value)
    menu.close()
    Citizen.Wait(500)
    permisje(gradee)
   
  end,
  function(data, menu) 
      menu.close()
      permisjea()
  end)
end


function zapros()

  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menu1',
  {
    title = ('Wpisz ID')
  },
  function(data, menu)
    local amount = tonumber(data.value)
    if amount == nil then
      ESX.ShowNotification('Błędne ID')
    else
      menu.close()
      
        TriggerServerEvent('w_organizacje:dolaczdoganguu', norg, amount)
    end
  end,
  function(data, menu)
    menu.close()
  end)

end








function pracownicy()
  local elements = {}

  ESX.TriggerServerCallback('w_organizacje:getworkers', function(info)
    elements = info
  
    ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'pracownicy',
  {
    title    = ('Zarządzanie członkami'),
    align = 'center', 
    elements = elements
  },
  function(data, menu) 
      menu.close()
      pracownicyzarzad(data.current.hex, data.current.grade)
      --TriggerServerEvent('w_organizacje:zgodanadolaczenie', job)
  end,
  function(data, menu) 
      menu.close() 
  end
)
end, norg)
  end



    
    function wezitem()


      ESX.TriggerServerCallback('w_organizacje:wezitem', function(callback_tabka)
        local elements = {} 
        elements = callback_tabka
        
      ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'wezitem', 
      {
        title    = ('Weź item'),
        align = 'center', 
        elements = elements
      },
      function(data, menu) 
        
        menu.close() 
    
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'odlozitem',
        {
          title = ('Ile chcesz wrzucić itemów do szafki')
        },
        function(data2, menu2)
          local amount = tonumber(data2.value)
          if amount == nil then
            --zla liczba
          else
            menu2.close()
            TriggerServerEvent('w_organizacje:wezitemT', norg, amount, data.current.item)
            Citizen.Wait(500)
            wezitem()
      
          end
        end,
        function(data2, menu2)
          menu2.close()
        end)
    
      end,
      function(data, menu) 
          menu.close() 
          szafka()
      end)
    end, norg, ngrade)
    
    end
    
    
    
    
    
    function odlozitem()
    
    
      ESX.TriggerServerCallback('w_organizacje:getinv', function(result)
          local elements = {}
          for i=1, #result.items, 1 do
    
              local invitem = result.items[i]
    
              if invitem.count > 0 then
                  table.insert(elements, { label = invitem.label .. ' | MAX:' .. invitem.count, ilosc = invitem.count, nazwa = invitem.name})
              end
          end
    
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'odloz_item',
              {
                  title		= 'Wrzuć itemy do organizacji',
                  align		= 'center',
                  elements = elements
              }, function(data, menu)
                  menu.close()
                  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'odlozitem',
      {
        title = ('Ile chcesz wrzucić itemów do szafki')
      },
      function(data2, menu2)
        local amount = tonumber(data2.value)
        if amount == nil then
          --zla liczba
        else
          menu2.close()
       
          TriggerServerEvent('w_organizacje:wrzucitemT',norg ,amount, data.current.nazwa)
          Citizen.Wait(500)
          odlozitem()
    
        end
      end,
      function(data2, menu2)
        menu2.close()
      end)
    
    
    
              end, function(data, menu)
                  menu.close()
                  szafka()
              end)
      end)
    
    
    end
    
    
    
    
    
    
    
    
    
    function wezbron()
    
    
      ESX.TriggerServerCallback('w_organizacje:wezbron', function(callback_tabka)
        local elements = {} 
        elements = callback_tabka
        
      ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'wezitem', 
      {
        title    = ('Weź broń'),
        align = 'center', 
        elements = elements
      },
      function(data, menu) 
        
        menu.close() 
            TriggerServerEvent('w_organizacje:wezbronT', norg, data.current.ammo, data.current.item)
            Citizen.Wait(200)
            wezbron()
    
    
      end,
      function(data, menu) 
          menu.close() 
          szafka()
      end)
    end, norg, ngrade)
    
    end
    
    
    
    function odlozbron()
    
    
      ESX.TriggerServerCallback('w_organizacje:getlod', function(callback_tabka)
    
        
    
        local elements = {} 
        elements = callback_tabka
        
      ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'wezitem', 
      {
        title    = ('Odłóż broń'),
        align = 'center', 
        elements = elements
      },
      function(data, menu) 
        
        menu.close() 
            TriggerServerEvent('w_organizacje:odlozbronT', norg, data.current.ammo, data.current.item)
        Citizen.Wait(200)
        odlozbron()
    
    
      end,
      function(data, menu) 
          menu.close() 
          szafka()
      end)
    end, norg, ngrade)
    
    end
    





    function wyplac(type)
    
      ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wyplac',
      {
        title = ('Ile pieniędzy chcesz wypłaćić?')
      },
      function(data, menu)
        local amount = tonumber(data.value)
        if amount == nil then
          ESX.ShowNotification('Podałeś złą wartość')
        else
          menu.close()
          TriggerServerEvent('w_organizacje:kontoz', amount, type, "wyp", norg)
          Citizen.Wait(200)
          szefmenu()
        end
      end,
      function(data, menu)
        menu.close()
      end)
    
    end
    
    
    function wplac(type)
    
      ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wplac',
      {
        title = ('Ile pieniędzy chcesz wpłacić?')
      },
      function(data, menu)
        local amount = tonumber(data.value)
        if amount == nil then
          ESX.ShowNotification('Podałeś złą wartość')
        else
          menu.close()
          TriggerServerEvent('w_organizacje:kontoz', amount, type, "wp",norg )
          Citizen.Wait(200)
          szefmenu()
        end
      end,
      function(data, menu)
        menu.close()
      end)
    
    end
    
    

    
  function pracownicyzarzad(hex, grade)
    local elements = {
      {label = "Awansuj", what = "awans"},
      {label = "Degraduj", what = "zwolnij"},
      {label = "Wyrzuć", what = "kick"},
    }


      ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'pracownicy2',
    {
      title    = ('Zarządzanie członkiem, obecna ranga: '..grade),
      align = 'center', 
      elements = elements
    },
    function(data, menu) 
        menu.close()
        if data.current.what == 'awans' then
          if tonumber(grade) >= 4 then
            msg("Gracz posiada najwyższą możliwą rangę")
          else
            msg("Pomyślnie awansowałeś członka")
            --awansujhere
              TriggerServerEvent('w_organizacje:changegrade', tonumber(grade)+1, hex)
          end
        elseif data.current.what == 'zwolnij' then

          if tonumber(grade) <= 0 then
            msg("Gracz posiada najniższą możliwą rangę")
          else
            --msg("Pomyślnie zmieniłeś rangę członka")
            --degradhere
            TriggerServerEvent('w_organizacje:changegrade', tonumber(grade)-1, hex)
          end
        elseif data.current.what == 'kick' then
            --msg("Pomyślnie wyrzuciłeś członka")
            TriggerServerEvent('w_organizacje:changegrade', -1, hex)
            --kick
        end

    end,
    function(data, menu) 
        menu.close() 
    end
  )

    end



    
RegisterNetEvent('w_organizacje:dolaczeniedoorg')
AddEventHandler('w_organizacje:dolaczeniedoorg', function(pracahere)

  ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'dolacz',
{
  title    = ('Czy chcesz dołączyć do '..pracahere),
  align = 'center', 
  elements = { 
    {label = ('Tak'),     value = 'tak'},
    {label = ('Nie'),     value = 'nie'},
  }
},
function(data, menu) 
  if data.current.value == 'tak' then
    menu.close()
    TriggerServerEvent('w_organizacje:zgodanadolaczenie', pracahere)
  else
    menu.close()
  end   
end,
function(data, menu) 
    menu.close() 
end
)

end)



function permisjea() 

  ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'menuname', 
  {
    title    = ('Menu Szefa '..norg),
    align = 'center', 
    elements = {
      {label = "Permisja: 0", grade = 0},
      {label = "Permisja: 1", grade = 1},
      {label = "Permisja: 2", grade = 2},
      {label = "Permisja: 3", grade = 3},
      {label = "Permisja: 4", grade = 4},
    }
  },
  function(data, menu) 
    menu.close()
    permisje(data.current.grade)
   
  end,
  function(data, menu) 
      menu.close()
      szefmenu()
  end
)

end
