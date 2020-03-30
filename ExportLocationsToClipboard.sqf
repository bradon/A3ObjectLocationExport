// Usage: 
// Place a playable unit in the center of the map, launch
// run _0 = [] execVM "ExportToClipboard.sqf"; in the console. This will place object data in clipboard (may take 30 sec to be in clipboard)
// Copy to a text editor eg notepad++
// delete lines that do not end in "]]]]," - they will be the longest, and they will contain data for clutter
// write curated file to @ALiVE\indexing\mapname\x\alive\addons\fnc_strategic\indexes\objects.mapname.sqf
// Run indexer
 
//get all houses - might need to divide into sectors for big maps 
//also may need to get other object types, but houses will get 90% of the way 
_all_houses = nearestObjects [player, ["house"], 20000]; 
_identified_houses = [] call CBA_fnc_hashCreate; 
{ 
 _current_house = _x; 
 //Tankbuster BI Forum 
 _excluded_buildings = ["Land_TTowerSmall_1_F", "Land_Dome_Big_F", "Cargo_Patrol_base_F", "Cargo_House_base_F", "Cargo_Tower_base_F", "Cargo_HQ_base_F","Piers_base_F", "PowerLines_base_F", "PowerLines_Wires_base_F", "PowerLines_Small_base_F", "Land_PowerPoleWooden_L_F",  "Land_Research_HQ_F", "Land_Research_house_V1_F", "Land_MilOffices_V1_F", "Land_TBox_F", "Land_Chapel_V1_F","Land_Chapel_Small_V2_F",  "Land_Chapel_Small_V1_F", "Land_BellTower_01_V1_F", "Land_BellTower_02_V1_F", "Land_fs_roof_F","Land_fs_feed_F", "Land_Windmill01_ruins_F", "Land_d_Windmill01_F", "Land_i_Windmill01_F","Land_i_Barracks_V2_F", "Land_spp_Transformer_F", "Land_dp_smallFactory_F", "Land_Shed_Big_F", "Land_Metal_Shed_F","Land_i_Shed_Ind_F","Land_Communication_anchor_F", "Land_TTowerSmall_2_F", "Land_Communication_F","Land_cmp_Shed_F", "Land_cmp_Tower_F", "Land_u_Shed_Ind_F", "Land_TBox_F", "Land_PowLines_ConcL", "Land_PowLines_WoodL"]; 
 if !((typeOf _current_house) in _excluded_buildings) then { 
  _current_p3d = (getModelInfo _current_house) select 1; 
  _current_pos = getPos _current_house; 
  _current_id = [((((str (_current_house)) splitString ":") select 0) splitString " ") select 1]; 
  _current_data = [_current_id, [_current_pos select 0, _current_pos select 1]]; 
  if !([_identified_houses, _current_p3d] call CBA_fnc_hashHasKey) then { 
   _identified_houses = [_identified_houses, _current_p3d, [_current_data]] call CBA_fnc_hashSet; 
  } else { 
   _old_entry = [_identified_houses, _current_p3d] call CBA_fnc_hashGet; 
   _identified_houses = [_identified_houses, _current_p3d, _old_entry + [_current_data]] call CBA_fnc_hashSet; 
  }; 
 }; 
} foreach _all_houses; 
 
_identified_p3ds = [_identified_houses] call CBA_fnc_hashKeys; 
bigstring = "wrp_objects = "+ endl+"["; 
{ 
 _current_p3d = _x; 
 _current_raw = [_identified_houses, _current_p3d] call CBA_fnc_hashGet; 
 _current_processed = []; 
 { 
  _current_data = [(parseNumber (_x select 0 select 0)) toFixed 0, [parseNumber (((_x select 1) select 0) toFixed 0), parseNumber (((_x select 1) select 1) toFixed 0)]]; 
  _current_processed pushBack _current_data; 
 } foreach _current_raw; 
 _current_complete = format ['["%1", %2],', _current_p3d, _current_processed]; 
 //diag_log _current_complete; 
 bigstring=bigstring+endl+_current_complete; 
} foreach _identified_p3ds; 
bigstring=bigstring+endl+endl+"// end" + endl;
copyToClipboard bigstring;
