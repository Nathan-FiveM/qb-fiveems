QBCore = exports['qb-core']:GetCoreObject()

prop_amb = false
veh_detect = 0
local ped, pedCoords = PlayerPedId(), GetEntityCoords(PlayerPedId())

CreateThread(function()
  while true do
    ped = PlayerPedId()
    pedCoords = GetEntityCoords(ped)
    Wait(500)
  end
end)

CreateThread(function()
  prop_exist = 0
  local sleep = 2000
  while true do
    sleep = 2000
    for _,g in pairs(Config.Hash) do
      local closestObject = GetClosestVehicle(pedCoords, 7.0, g.hash, 18)
      if closestObject ~= 0 then
        veh_detect = closestObject
        veh_detection = g.detection
        prop_depth = g.depth
        prop_height = g.height
      end
    end
    if not prop_amb and GetVehiclePedIsIn(ped) == 0 and DoesEntityExist(veh_detect) then
      sleep = 5
      local veh_coords  = GetEntityCoords(veh_detect)
      local veh_forward = GetEntityForwardVector(veh_detect)
      local coords       = veh_coords + veh_forward * - veh_detection
      local coords_spawn = veh_coords + veh_forward * - (veh_detection + 4.0)
      if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, coords.x, coords.y, coords.z) <= 5.0 then
        if not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3) and not IsEntityAttachedToAnyVehicle(ped) then
          local prop
          for k,v in pairs(Config.Lits) do
            prop = GetClosestVehicle(pedCoords, 4.0, v.lit)
            if prop ~= 0 then
               prop_exist = prop
            end
          end
        end
      end
    end
    Wait(sleep)
  end
end)

function prendre(propObject, hash)
  NetworkRequestControlOfEntity(propObject)

  LoadAnim("anim@heists@box_carry@")

  AttachEntityToEntity(propObject, ped, ped, -0.05, 1.3, -0.4 , 180.0, 180.0, 180.0, 0.0, false, false, false, false, 2, true)

  while IsEntityAttachedToEntity(propObject, ped) do

    Wait(5)

    if not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3) then
      TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
    end

    if IsPedDeadOrDying(ped) then
      ClearPedTasksImmediately(ped)
      SetVehicleExtra(propObject, 1, 1)
      SetVehicleExtra(propObject, 2, 0)
      DetachEntity(propObject, true, true)
      SetVehicleOnGroundProperly(propObject)
    end
    local veh_coords = GetEntityCoords(veh_detect)
    if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, veh_coords.x, veh_coords.y, veh_coords.z) <= 9.0 then
      if IsControlJustPressed(0, 47) then
        ClearPedTasksImmediately(ped)
        SetVehicleExtra(propObject, 1, 1)
        SetVehicleExtra(propObject, 2, 0)
        DetachEntity(propObject, true, true)
        prop_amb = true
        in_ambulance(propObject, veh_detect, prop_depth, prop_height)
      end
      if IsControlJustPressed(0, 38) then
        if IsVehicleDoorFullyOpen(veh_detect, 5) then
          SetVehicleDoorShut(veh_detect, 5, false)
        else
          SetVehicleDoorOpen(veh_detect, 5, false)
        end
      end
      if IsControlJustPressed(0, 20) then
        if IsVehicleDoorFullyOpen(veh_detect, 4) then
          SetVehicleDoorShut(veh_detect, 4, false)
        else
          SetVehicleDoorOpen(veh_detect, 4, false)
        end
      end
    else
      hintToDisplay("Press ~INPUT_SPECIAL_ABILITY_SECONDARY~ to drop stretcher")
    end

    if IsControlJustPressed(0, 29) then
      ClearPedTasksImmediately(ped)
      SetVehicleExtra(propObject, 1, 1)
      SetVehicleExtra(propObject, 2, 0)
      DetachEntity(propObject, true, false)
      SetVehicleOnGroundProperly(propObject)
    end

  end
end

function in_ambulance(propObject, amb, depth, height)
  veh_detect = 0
  NetworkRequestControlOfEntity(amb)

  AttachEntityToEntity(propObject, amb, GetEntityBoneIndexByName(amb, "bonnet"), 0.0, depth, height, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 2, true)

  while IsEntityAttachedToEntity(propObject, amb) do
    Wait(5)

    if GetVehiclePedIsIn(ped) == 0 then
      local veh_coords2 = GetEntityCoords(amb)
      if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, veh_coords2.x, veh_coords2.y, veh_coords2.z) <= 7.0 then
        if IsControlJustPressed(0, 47) then
          DetachEntity(propObject, true, true)
          prop_amb = false
          SetEntityHeading(ped, GetEntityHeading(ped) - 180.0)
          SetVehicleExtra(propObject, 1, 0)
          SetVehicleExtra(propObject, 2, 1)
          prendre(propObject)
        end
        if IsControlJustPressed(0, 38) then
          if IsVehicleDoorFullyOpen(amb, 5) then
            SetVehicleDoorShut(amb, 5, false)
          else
            SetVehicleDoorOpen(amb, 5, false)
          end
        end
        if IsControlJustPressed(0, 20) then
          if IsVehicleDoorFullyOpen(amb, 4) then
            SetVehicleDoorShut(amb, 4, false)
          else
            SetVehicleDoorOpen(amb, 4, false)
          end
        end

        if IsControlJustPressed(0, 18) then
          if IsVehicleExtraTurnedOn(veh_detect, 11) then
            SetVehicleExtra(veh_detect, 11, 1)
            SetVehicleExtra(veh_detect, 12, 1)
            SetVehicleExtra(veh_detect, 8, 1)
          else
            SetVehicleExtra(veh_detect, 11, 0)
            SetVehicleExtra(veh_detect, 12, 0)
            SetVehicleExtra(veh_detect, 8, 0)
          end
        end

        if IsControlJustPressed(0, 217) then
          if IsVehicleExtraTurnedOn(veh_detect, 10) then
            SetVehicleExtra(veh_detect, 10, 1)
            SetVehicleExtra(veh_detect, 9, 0)
            SetVehicleExtra(veh_detect, 11, 0)
            SetVehicleExtra(veh_detect, 12, 0)
            SetVehicleExtra(veh_detect, 8, 0)
          else
            SetVehicleExtra(veh_detect, 10, 0)
            SetVehicleExtra(veh_detect, 9, 1)
            SetVehicleExtra(veh_detect, 11, 1)
            SetVehicleExtra(veh_detect, 12, 1)
            SetVehicleExtra(veh_detect, 8, 1)
          end
        end
      end
    end
  end
end

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Wait(1)
  end
end

function hintToDisplay(text)
  BeginTextCommandDisplayHelp("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Menu
RegisterNetEvent('qb-fivemems:client:AmbulanceMenu', function()
  exports['qb-menu']:openMenu({
      {
          header = "AMBULANCE MENU",
          isMenuHeader = true
      },
      {
          header = "STOW STRETCHER",
          txt = "",
          params = {
              event = 'qb-fivemems:client:Ambulance',
              args = '1'
          }
      },
      {
          header = "GRAB STRETCHER",
          txt = "",
          params = {
              event = 'qb-fivemems:client:Ambulance',
              args = '2'
          }
      },
      {
          header = "EXTEND POWERLOAD",
          txt = "",
          params = {
              event = 'qb-fivemems:client:Ambulance',
              args = '3'
          }
      },
      {
        header = "EXTRAS",
        txt = "",
        params = {
            event = 'qb-fivemems:client:Ambulance',
            args = '4'
        }
      },
      {
        header = "TOGGLE LIGHTS",
        txt = "",
        params = {
            event = 'qb-fivemems:client:Ambulance',
            args = '5'
        }
      },
      {
        header = "TOGGLE BACKDOORS",
        txt = "",
        params = {
            event = 'qb-fivemems:client:Ambulance',
            args = '6'
        }
      },
      {
        header = "GET",
        txt = "",
        params = {
            event = 'qb-fivemems:client:Ambulance',
            args = '7'
        }
      },
      {
        header = "GRAB",
        txt = "",
        params = {
            event = 'qb-fivemems:client:Ambulance',
            args = '8'
        }
      },
  })
end)

RegisterNetEvent('qb-fivemems:client:StretcherMenu', function()
    exports['qb-menu']:openMenu({
        {
            header = "STRETCHER MENU",
            isMenuHeader = true
        },
        {
            header = "TOGGLE IV",
			      txt = "",
			      params = {
                event = 'qb-fivemems:client:Stretcher',
                args = '1'
            }
        },
        {
            header = "TOGGLE LP15",
			      txt = "",
			      params = {
                event = 'qb-fivemems:client:Stretcher',
                args = '2'
            }
        },
        {
            header = "TOGGLE LUCAS",
			      txt = "",
			      params = {
                event = 'qb-fivemems:client:Stretcher',
                args = '3'
            }
        },
        {
          header = "TOGGLE BACKBOARD",
          txt = "",
          params = {
              event = 'qb-fivemems:client:Stretcher',
              args = '4'
          }
        },
        {
          header = "TOGGLE SCOOP",
          txt = "",
          params = {
              event = 'qb-fivemems:client:Stretcher',
              args = '5'
          }
        },
        {
          header = "TOGGLE SEAT",
          txt = "",
          params = {
              event = 'qb-fivemems:client:Stretcher',
              args = '6'
          }
        },
        {
          header = "GRAB STRETCHER",
          txt = "",
          params = {
              event = 'qb-fivemems:client:Stretcher',
              args = '7'
          }
        },
    })
end)

RegisterNetEvent('qb-fivemems:client:StretcherSeatMenu', function()
  exports['qb-menu']:openMenu({
      {
          header = "STRETCHER SEAT MENU",
          isMenuHeader = true
      },
      {
          header = "Lie Down",
          txt = "",
          params = {
              event = 'qb-fivemems:client:StretcherSeats',
              args = '1'
          }
      },
      {
          header = "Lay Still",
          txt = "",
          params = {
              event = 'qb-fivemems:client:StretcherSeats',
              args = '2'
          }
      },
      {
          header = "Sit on the right side",
          txt = "",
          params = {
              event = 'qb-fivemems:client:StretcherSeats',
              args = '3'
          }
      },
      {
        header = "Sit on the left side",
        txt = "",
        params = {
            event = 'qb-fivemems:client:StretcherSeats',
            args = '4'
        }
      },
      {
        header = "Sit Up",
        txt = "",
        params = {
            event = 'qb-fivemems:client:StretcherSeats',
            args = '5'
        }
      },
      {
        header = "Recieve CPR",
        txt = "",
        params = {
            event = 'qb-fivemems:client:StretcherSeats',
            args = '6'
        }
      },
      {
        header = "Lay sideways",
        txt = "",
        params = {
            event = 'qb-fivemems:client:StretcherSeats',
            args = '7'
        }
      },
      {
        header = "GET OUT OF BED",
        txt = "",
        params = {
            event = 'qb-fivemems:client:StretcherSeats',
            args = '8'
        }
      },
  })
end)

RegisterNetEvent('qb-fivemems:client:Stretcher', function(args)
  local closestObject, Lit = nil, nil
  closestObject = nil

  for k,v in pairs(Config.Lits) do
    closestObject = GetClosestVehicle(pedCoords, 3.0, v.lit, 70)
    if DoesEntityExist(closestObject) then
      Lit = v
      break
    end
  end

  local propCoords = GetEntityCoords(closestObject)
  local propForward = GetEntityForwardVector(closestObject)
  local litCoords = (propCoords + propForward)
  local sitCoords = (propCoords + propForward * 0.1)
  local pickupCoords = (propCoords + propForward * 1.2)
  local pickupCoords2 = (propCoords + propForward * - 1.2)

  local args = tonumber(args)
  if args == 1 then
      -- Event 1 TOGGLE IV
      toggle = not toggle
      if toggle then
        SetVehicleExtra(closestObject, 5, 0)
      else
        SetVehicleExtra(closestObject, 5, 1)
      end
  elseif args == 2 then
      -- Event 2 TOGGLE LP15
      toggle = not toggle
      if toggle then
        SetVehicleExtra(closestObject, 3, 1)
      else
        SetVehicleExtra(closestObject, 3, 0)
      end
  elseif args == 3 then
      -- Event 3 TOGGLE LUCAS
      toggle = not toggle
      if toggle then
        SetVehicleExtra(closestObject, 6, 0)
      else
        SetVehicleExtra(closestObject, 6, 1)
      end
  elseif args == 4 then
      -- Event 4 TOGGLE BACKBOARD
      toggle = not toggle
      if toggle then
        SetVehicleExtra(closestObject, 4, 0)
      else
        SetVehicleExtra(closestObject, 4, 1)
      end
  elseif args == 5 then
      -- Event 5 TOGGLE SCOOP
      toggle = not toggle
      if toggle then
        SetVehicleExtra(closestObject, 7, 0)
      else
        SetVehicleExtra(closestObject, 7, 1)
      end
  elseif args == 6 then
      -- Event 6 TOGGLE SEAT
      if IsVehicleDoorFullyOpen(closestObject, 4) then
        SetVehicleDoorShut(closestObject, 4, false)
      else
        SetVehicleDoorOpen(closestObject, 4, false)
      end
  elseif args == 7 then
    -- Event 7 GRAB STRETCHER
    SetVehicleExtra(closestObject, 1, 0)
    SetVehicleExtra(closestObject, 2, 1)
    prendre(closestObject)
  end
end)

RegisterNetEvent('qb-fivemems:client:StretcherSeats', function(args)
  local closestObject, Lit = nil, nil
  closestObject = nil

  for k,v in pairs(Config.Lits) do
    closestObject = GetClosestVehicle(pedCoords, 3.0, v.lit, 70)
    if DoesEntityExist(closestObject) then
      Lit = v
      break
    end
  end

  local propCoords = GetEntityCoords(closestObject)
  local propForward = GetEntityForwardVector(closestObject)
  local litCoords = (propCoords + propForward)
  local sitCoords = (propCoords + propForward * 0.1)
  local pickupCoords = (propCoords + propForward * 1.2)
  local pickupCoords2 = (propCoords + propForward * - 1.2)

  local args = tonumber(args)
  if args == 1 then
      -- Event 1 Lie Down
      LoadAnim("savecouch@")
      AttachEntityToEntity(ped, closestObject, ped, 0, 0.1, 1.2, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)
      TaskPlayAnim(ped, "savecouch@", "t_sleep_loop_couch", 8.0, 8.0, -1, 1, 0, false, false, false)
  elseif args == 2 then
      -- Event 2 Lay Still
      LoadAnim("anim@gangops@morgue@table@")
      AttachEntityToEntity(ped, closestObject, ped, 0.0, 0.1, 1.52, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)
      TaskPlayAnim(ped, "anim@gangops@morgue@table@", "body_search", 8.0, 8.0, -1, 1, 0, false, false, false)
  elseif args == 3 then
    -- Event 3 Sit on the right side
    LoadAnim("amb@prop_human_seat_chair_food@male@base")
    AttachEntityToEntity(ped, closestObject, ped, 0.0, -0.2, 0.55, 0.0, 0.0, -90.0, 0.0, false, false, false, false, 2, true)
    TaskPlayAnim(ped, "amb@prop_human_seat_chair_food@male@base", "base", 8.0, 8.0, -1, 1, 0, false, false, false)
  elseif args == 4 then
    -- Event 4 Sit on the left side
    LoadAnim("amb@prop_human_seat_chair_food@male@base")
    AttachEntityToEntity(ped, closestObject, ped, 0.0, -0.2, 0.55, 0.0, 0.0, 90.0, 0.0, false, false, false, false, 2, true)
    TaskPlayAnim(ped, "amb@prop_human_seat_chair_food@male@base", "base", 8.0, 8.0, -1, 1, 0, false, false, false)
  elseif args == 5 then
    -- Event 5 Sit Up
    LoadAnim("timetable@jimmy@mics3_ig_15@")
    AttachEntityToEntity(ped, closestObject, ped, 0.0, 0.15, 1.52, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)
    TaskPlayAnim(ped, "timetable@jimmy@mics3_ig_15@", "mics3_15_base_jimmy", 8.0, 8.0, -1, 1, 0, false, false, false)
  elseif args == 6 then
    -- Event 6 Recieve CPR
    LoadAnim("missheistfbi3b_ig8_2")
    AttachEntityToEntity(ped, closestObject, ped, 0.0, 0.1, 1.52, 0.0, 0.0, 175.0, 0.0, false, false, false, false, 2, true)
    TaskPlayAnim(ped, "missheistfbi3b_ig8_2", "cpr_loop_victim", 8.0, 8.0, -1, 1, 0, false, false, false)
  elseif args == 7 then
    -- Event 7 Lay sideways
    LoadAnim("amb@world_human_bum_slumped@male@laying_on_right_side@base")
    AttachEntityToEntity(ped, closestObject, ped, 0.2, 0.1, 1.6, 0.0, 0.0, 100.0, 0.0, false, false, false, false, 2, true)
    TaskPlayAnim(ped, "amb@world_human_bum_slumped@male@laying_on_right_side@base", "base", 8.0, 8.0, -1, 1, 0, false, false, false)
  elseif args == 8 then
    -- Event 8 GET OUT OF BED
    DetachEntity(ped, true, true)
    SetEntityCoords(ped, propCoords + propForward * - Lit.distance_stop)
  end
end)

RegisterNetEvent('qb-fivemems:client:Ambulance', function(args)
  local closestObject, Lit = nil, nil
  closestObject = nil

  for k,v in pairs(Config.Lits) do
    closestObject = GetClosestVehicle(pedCoords, 3.0, v.lit, 70)
    if DoesEntityExist(closestObject) then
      Lit = v
      break
    end
  end

  local propCoords = GetEntityCoords(closestObject)
  local propForward = GetEntityForwardVector(closestObject)
  local litCoords = (propCoords + propForward)
  local sitCoords = (propCoords + propForward * 0.1)
  local pickupCoords = (propCoords + propForward * 1.2)
  local pickupCoords2 = (propCoords + propForward * - 1.2)

  local args = tonumber(args)
  if args == 1 then
      -- Event 1 PUT STRETCHER IN AMBULANCE
      DetachEntity(propObject, true, true)
      prop_amb = false
      SetEntityHeading(ped, GetEntityHeading(ped) - 180.0)
      SetVehicleExtra(propObject, 1, 0)
      SetVehicleExtra(propObject, 2, 1)
      prendre(propObject)
  elseif args == 2 then
      -- Event 2 GRAB STRETCHER
      if IsVehicleDoorFullyOpen(veh_detect, 5) then
        SetVehicleDoorShut(veh_detect, 5, false)
      else
        SetVehicleDoorOpen(veh_detect, 5, false)
      end
  elseif args == 3 then
      -- Event 3 EXTEND POWERLOAD
      if IsVehicleDoorFullyOpen(veh_detect, 4) then
        SetVehicleDoorShut(veh_detect, 4, false)
      else
        SetVehicleDoorOpen(veh_detect, 4, false)
      end
  elseif args == 4 then
      -- Event 4 EXTRAS
      if IsVehicleExtraTurnedOn(veh_detect, 10) then
        SetVehicleExtra(veh_detect, 10, 1)
        SetVehicleExtra(veh_detect, 9, 0)
        SetVehicleExtra(veh_detect, 11, 0)
        SetVehicleExtra(veh_detect, 12, 0)
        SetVehicleExtra(veh_detect, 8, 0)
      else
        SetVehicleExtra(veh_detect, 10, 0)
        SetVehicleExtra(veh_detect, 9, 1)
        SetVehicleExtra(veh_detect, 11, 1)
        SetVehicleExtra(veh_detect, 12, 1)
        SetVehicleExtra(veh_detect, 8, 1)
      end
  elseif args == 5 then
      -- Event 5 TOGGLE LIGHTS
      if IsVehicleExtraTurnedOn(veh_detect, 11) then
        SetVehicleExtra(veh_detect, 11, 1)
        SetVehicleExtra(veh_detect, 12, 1)
        SetVehicleExtra(veh_detect, 8, 1)
      else
        SetVehicleExtra(veh_detect, 11, 0)
        SetVehicleExtra(veh_detect, 12, 0)
        SetVehicleExtra(veh_detect, 8, 0)
      end
  elseif args == 6 then
    -- Event 6 TOGGLE BACKDOORS
      if IsVehicleDoorFullyOpen(veh_detect, 5) then
        SetVehicleDoorShut(veh_detect, 5, false)
      else
        SetVehicleDoorOpen(veh_detect, 5, false)
      end
  end
end)