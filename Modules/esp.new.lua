--[[------------------------------------------------
|
|    Library Made for IonHub (discord.gg/seU6gab)
|    Developed by tatar0071#0627 and tested#0021 and mickey
|    IF YOU USE THIS, PLEASE CREDIT DEVELOPER(S)!
|
--]]------------------------------------------------

if esp then
    esp.unload()
end

-- // Services & Functions
local players     = game:GetService("Players");
local localplayer = players.LocalPlayer
local run_service = game:GetService("RunService");
local renderstepped = run_service.RenderStepped
local core_gui    = game:GetService("CoreGui");
local camera      = workspace.CurrentCamera;
local world_to_viewport_point = camera.WorldToViewportPoint;
local instance_new = Instance.new
local model = instance_new("Model")
local connect = model.Changed.Connect
local remove, destroy = model.Remove, model.Destroy
local get_primary_part_cframe = model.GetPrimaryPartCFrame
local find_first_child, find_first_child_of_class = model.FindFirstChild, model.FindFirstChildOfClass
local color3_new = Color3.new
local c3_lerp = color3_new().lerp
local vector2_new = Vector2.new
local drawing_new = Drawing.new
local cframe_new = CFrame.new
local math_tan, math_rad, math_floor, math_round = math.tan, math.rad, math.floor, math.round

-- // Library
local esp = {
    settings = {
        enabled = false;
        text_settings = {
            name     = {enabled = false; position = "top"; color = color3_new(1, 1, 1); color_outline = color3_new(0, 0, 0); possible_positions = {"top", "bottom", "left", "right"}};
            distance = {enabled = false; position = "bottom"; color = color3_new(1, 1, 1); color_outline = color3_new(0, 0, 0); convert = "meters"; possible_positions = {"top", "bottom", "left", "right"}};
            health   = {enabled = false; position = "right"; color = color3_new(1, 1, 1); color_outline = color3_new(0, 0, 0); possible_positions = {"top", "bottom", "left", "right", "bar"}};
            weapon   = {enabled = false; position = "right"; color = color3_new(1, 1, 1); color_outline = color3_new(0, 0, 0); possible_positions = {"top", "bottom", "left", "right"}};
        };
        health_settings = {
            bar = {enabled = false; inverse = false; position = "left"; full_color = color3_new(0, 1, 0); empty_color = color3_new(1, 0, 0)};
        };
        box        = {enabled = false; color = color3_new(1, 1, 1); color_outline = color3_new(0, 0, 0); mode = "default"};
        box_fill   = {enabled = false; color = color3_new(1, 1, 1); transparency = 0.5};
        snapline   = {enabled = false; color = color3_new(1, 1, 1); target = "Head"};
        angle      = {enabled = false; color = color3_new(1, 1, 1)};
        chameleon  = {enabled = false; color = color3_new(1, 1, 1); outline_color = color3_new(0, 0, 0), transparency = 0.5, outline_transparency = 0};
        maximal_distance = 1000;
        font             = 2;
        font_size        = 13;
        bold_text        = false;
        preciseness      = 1;
        highlight        = {enabled = false, color = color3_new(1, 0, 0), target = nil};
        team_check       = false;
        box_custom_size_x = 4;
        box_custom_size_y = 6;
    };
    drawings  = {};
    overrides = {};
    objects   = {};
} esp.__index = esp; 
local esp_settings = esp.settings;

-- // Library Functions 
local connections, instances = {}, {}
local esp_get_character, esp_get_parts, esp_get_bounding_box, esp_round, esp_get_tool, esp_get_team, esp_get_health
local utility_connection
local utility = {}; do
    utility.__index = utility
    function utility.draw(class, properties)
        local drawing = drawing_new(class)
        for i,v in pairs(properties) do
            drawing[i] = v
        end
        return drawing
    end
    local utility_draw = utility.draw
    function utility.instance(class, properties)
        local inst = instance_new(class)
        for i,v in pairs(properties or {}) do
            local s,e = pcall(function()
                inst[i] = v
            end)
        end
        instances[#instances+1] = inst
        return inst
    end
    function utility.connection(signal, func)
        local c = connect(signal, func)
        connections[#connections+1] = c
        return c
    end
    utility_connection = utility.connection
    esp.unload = function()
        --[[for _,c in pairs(connections) do
            c:Disconnect()
        end
        for _, obj in next, esp.drawings do
            if i == "chams" then
                obj:Destroy();
            end;
            obj:Remove();
        end
        esp.drawings = nil
        instances = nil
        connections = nil
        esp = nil
        getgenv().esp = nil]]
    end
    local esp_overrides = esp.overrides
    esp.add = function(player)
        if player ~= localplayer then 
            local data = {
                box           = utility_draw("Square", {Thickness = 1; ZIndex = 3; Filled = false; Color = esp.settings.box.color});
                box_outline   = utility_draw("Square", {Thickness = 3; ZIndex = 2; Filled = false});
                box_fill      = utility_draw("Square", {Thickness = 1; ZIndex = 1; Transparency = 0.5; Filled = true});
                healthbar         = utility_draw("Square", {Thickness = 1; ZIndex = 3; Filled = true});
                healthbar_outline = utility_draw("Square", {Thickness = 3; ZIndex = 2; Filled = true});
                name          = utility_draw("Text", {Text = player.Name; Font = esp.settings.font; Size = esp.settings.font_size; ZIndex = 3; Outline = true; Center = true});
                name_bold     = utility_draw("Text", {Text = player.Name; Font = esp.settings.font; Size = esp.settings.font_size; ZIndex = 3; Outline = true; Center = true});
                distance      = utility_draw("Text", {Font = esp.settings.font; Size = esp.settings.font_size; ZIndex = 3; Outline = true; Center = true});
                distance_bold = utility_draw("Text", {Font = esp.settings.font; Size = esp.settings.font_size; ZIndex = 3; Outline = true; Center = true});
                health        = utility_draw("Text", {Font = esp.settings.font; Size = esp.settings.font_size; ZIndex = 3; Outline = true; Center = true});
                health_bold   = utility_draw("Text", {Font = esp.settings.font; Size = esp.settings.font_size; ZIndex = 3; Outline = true; Center = true});
                weapon        = utility_draw("Text", {Font = esp.settings.font; Size = esp.settings.font_size; ZIndex = 3; Outline = true; Center = true});
                weapon_bold   = utility_draw("Text", {Font = esp.settings.font; Size = esp.settings.font_size; ZIndex = 3; Outline = true; Center = true});
                snapline      = utility_draw("Line", {Thickness = 1; ZIndex = 3; Color = esp.settings.snapline.color});
                angle         = utility_draw("Line", {Thickness = 1; ZIndex = 3; Color = esp.settings.snapline.color});
                chameleon     = utility.instance("Highlight", {Parent = core_gui; DepthMode = Enum.HighlightDepthMode.AlwaysOnTop});
            }; esp.drawings[player] = data;
        end;
    end;

    esp.remove = function(player)
        if esp.drawings[player] then
            for _, obj in next, esp.drawings[player] do
                if i == "chams" then
                    obj:Destroy();
                end;
                obj:Remove();
            end
            esp.drawings[player] = nil;
        end
    end;

    esp.get_bounding_box = function(character, preciseness, part)
        if (not preciseness) then return; end

        if (preciseness == 1) then
            return preciseness, get_primary_part_cframe(character);
        end
        if (preciseness == 2) then 
            local part_cframe, part_size = part.CFrame, part.Size;
            local X, Y, Z = part_size.X, part_size.Y, part_size.Z;
            return preciseness, {
                TBRC = part_cframe * cframe_new(X, Y * 1.3, Z);
                TBLC = part_cframe * cframe_new(-X, Y * 1.3, Z);
                TFRC = part_cframe * cframe_new(X, Y * 1.3, -Z);
                TFLC = part_cframe * cframe_new(-X, Y * 1.3, -Z);
                BBRC = part_cframe * cframe_new(X, -Y * 1.6, Z);
                BBLC = part_cframe * cframe_new(-X, -Y * 1.6, Z);
                BFRC = part_cframe * cframe_new(X, -Y * 1.6, -Z);
                BFLC = part_cframe * cframe_new(-X, -Y * 1.6, -Z);
            };
        end;
    end;
    esp_get_bounding_box = esp.get_bounding_box

    esp.round = function(v)
        return vector2_new(math_floor(v.X + 0.5), math_floor(v.Y + 0.5))
    end;
    esp_round = esp.round

    esp.v3_to_v2 = function(v)
        return vector2_new(v.X, v.Y)
    end
    esp_v3_to_v2 = esp.v3_to_v2

    esp.toggle = function(boolean)
        esp_settings.enabled = boolean;
    end;

    esp.get_character = function(player)
        if esp_overrides.get_character ~= nil then
            return esp_overrides.get_character(player);
        end;
        return player.Character;
    end;
    esp_get_character = esp.get_character

    esp.get_tool = function(player, character)
        if esp_overrides.get_tool ~= nil then
            return esp_overrides.get_tool(player, character);
        end;
        if character then
            local tool = find_first_child_of_class(character, "Tool");
            if tool then
                return tool.Name;
            end;
        end;
        return "Hands";
    end;
    esp_get_tool = esp.get_tool

    esp.get_team = function(player)
        if esp_overrides.get_team ~= nil then
            return esp_overrides.get_team(player);
        end;
        return player.Team;
    end;
    esp_get_team = esp.get_team

    esp.get_health = function(player, character)
        if esp_overrides.get_health ~= nil then
            return esp_overrides.get_health(player, character);
        end;
        if character then
            local humanoid = find_first_child_of_class(character, "Humanoid");
            if humanoid then
                return humanoid.Health, humanoid.MaxHealth;
            end;
        end;
        return 100, 100;
    end;
    esp_get_health = esp.get_health

    esp.get_parts = function(character)
        if esp_overrides.get_parts ~= nil then
            return esp_overrides.get_parts(player, character);
        end;
        if character == nil then
            return false
        end
        local head, root_part, humanoid = find_first_child(character, "Head"), find_first_child(character, "HumanoidRootPart"), find_first_child_of_class(character, "Humanoid");
        if head and root_part and humanoid then
            return head, root_part, humanoid
        end
        return false
    end
    esp_get_parts = esp.get_parts

    -- Objects
    esp.update_players = function()
        local esp_drawings = esp.drawings
        local fov_magic = math_tan(math_rad(camera.FieldOfView / 2)) * 2
        for plr, data in pairs(esp_drawings) do
            local character   = esp_get_character(plr);
            local head, root_part, humanoid = esp_get_parts(character);
            local box         = data.box;
            local box_fill    = data.box_fill;
            local box_outline = data.box_outline;
            local healthbar   = data.healthbar;
            local healthbar_outline = data.healthbar_outline;
            local snapline          = data.snapline;
            local angle             = data.angle;
            local chameleon         = data.chameleon;
            local name              = data.name;
            local name_bold         = data.name_bold;
            local distance          = data.distance;
            local distance_bold     = data.distance_bold;
            local weapon            = data.weapon;
            local weapon_bold       = data.weapon_bold;
            local health_text       = data.health;
            local health_bold       = data.health_bold;

            if not head then
                name.Visible              = false;
                distance.Visible          = false;
                weapon.Visible            = false;
                health_text.Visible       = false;
                box.Visible               = false;
                box_fill.Visible          = false;
                box_outline.Visible       = false;
                healthbar.Visible         = false;
                healthbar_outline.Visible = false;
                snapline.Visible          = false;
                angle.Visible             = false;
                chameleon.Enabled         = false;
                continue;
            end;

            local current_health, max_health = esp_get_health(plr, character);

            -- // Math
            local preciseness, dimensions = esp_get_bounding_box(character, esp_settings.preciseness, root_part);
            local hrp_position, on_screen = world_to_viewport_point(camera, root_part.Position);
            local hrp_position_depth = hrp_position.z;
            local stud_conversion, meter_conversion = math_floor(hrp_position_depth + 0.5), math_floor(hrp_position_depth / 3.5714285714 + 0.5);

            if not on_screen then
                name.Visible              = false;
                distance.Visible          = false;
                weapon.Visible            = false;
                health_text.Visible       = false;
                box.Visible               = false;
                box_fill.Visible          = false;
                box_outline.Visible       = false;
                healthbar.Visible         = false;
                healthbar_outline.Visible = false;
                snapline.Visible          = false;
                angle.Visible             = false;
                chameleon.Enabled         = false;
                continue;
            end;

            if esp_settings.team_check and esp_get_team(plr) == esp_get_team(localplayer) then
                name.Visible              = false;
                distance.Visible          = false;
                weapon.Visible            = false;
                health_text.Visible       = false;
                box.Visible               = false;
                box_fill.Visible          = false;
                box_outline.Visible       = false;
                healthbar.Visible         = false;
                healthbar_outline.Visible = false;
                snapline.Visible          = false;
                angle.Visible             = false;
                chameleon.Enabled         = false;
                continue;
            end;

            if not esp_settings.enabled and on_screen and meter_conversion < esp_settings.maximal_distance then
                name.Visible              = false;
                distance.Visible          = false;
                weapon.Visible            = false;
                health_text.Visible       = false;
                box.Visible               = false;
                box_fill.Visible          = false;
                box_outline.Visible       = false;
                healthbar.Visible         = false;
                healthbar_outline.Visible = false;
                snapline.Visible          = false;
                angle.Visible             = false;
                chameleon.Enabled         = false;
                continue;
            end;

            -- // Static ESP
            if preciseness == 1 then
                local scale_factor = 1 / (hrp_position.Z * fov_magic) * 1000;
                local width, height = math_round(esp_settings.box_custom_size_x * scale_factor), math_round(esp_settings.box_custom_size_y * scale_factor);
                local vector_2 = esp_v3_to_v2(hrp_position)
                local x, y = math_round(vector_2.x), math_round(vector_2.y);

                local box_size = vector2_new(width, height);
                local box_position = vector2_new(math_round(x - width / 2), math_round(y - height / 2));

                -- // Offsets
                local top_offset = 0;
                local bottom_offset = 0;
                local left_offset_x, left_offset_y = 0, 0;
                local right_offset_x, right_offset_y = 0, 0;

                box.Position   = box_position;
                box.Size       = box_size;
                box_outline.Position  = box_position;
                box_outline.Size      = box_size;
                box_fill.Position     = box_position;
                box_fill.Size         = box_size;

                -- // Healthbar
                local health_settings = esp_settings.health_settings
                local health_settings_bar = health_settings.bar
                local bar_enabled = health_settings_bar.enabled
                if bar_enabled then
                    local healthbar_position = health_settings_bar.position
                    if healthbar_position == "right" then
                        healthbar_outline.Size = vector2_new(3, height + 2)
                        healthbar_outline.Position = box_position + vector2_new(width + 2, -1)
                        if health_settings_bar.inverse then
                            healthbar.Position = healthbar_outline.Position + vector2_new(1, 1)
                            healthbar.Size = vector2_new(1, (healthbar_outline.Size.Y - 2) * (current_health / max_health))
                        else
                            healthbar.Position = healthbar_outline.Position + vector2_new(1, -1 + healthbar_outline.Size.Y)
                            healthbar.Size = vector2_new(1, -((healthbar_outline.Size.Y - 2) * (current_health / max_health)))
                        end
                        right_offset_x = right_offset_x + 4
                    elseif healthbar_position == "top" then
                        healthbar_outline.Size = vector2_new(width + 2, 3)
                        healthbar_outline.Position = box_position + vector2_new(-1, -5)
                        if health_settings_bar.inverse then
                            healthbar.Size = vector2_new(-(healthbar_outline.Size.X - 2) * (current_health / max_health), 1)
                            healthbar.Position = healthbar_outline.Position + vector2_new(healthbar_outline.Size.X - 1, 1)
                        else
                            healthbar.Position = healthbar_outline.Position + vector2_new(1, 1)
                            healthbar.Size = vector2_new(((healthbar_outline.Size.X - 2) * (current_health / max_health)), 1)
                        end
                        top_offset = top_offset + 4
                    elseif healthbar_position == "bottom" then
                        healthbar_outline.Size = vector2_new(width + 2, 3)
                        healthbar_outline.Position = box_position + vector2_new(-1, height + 2)
                        if health_settings_bar.inverse then
                            healthbar.Size = vector2_new(-(healthbar_outline.Size.X - 2) * (current_health / max_health), 1)
                            healthbar.Position = healthbar_outline.Position + vector2_new(healthbar_outline.Size.X - 1, 1)
                        else
                            healthbar.Position = healthbar_outline.Position + vector2_new(1, 1)
                            healthbar.Size = vector2_new((healthbar_outline.Size.X - 2) * (current_health / max_health), 1)
                        end
                        bottom_offset = bottom_offset + 4
                    else
                        healthbar_outline.Size = vector2_new(3, height + 2)
                        healthbar_outline.Position = box_position + vector2_new(-5, -1)
                        if health_settings_bar.inverse then
                            healthbar.Position = healthbar_outline.Position + vector2_new(1, 1)
                            healthbar.Size = vector2_new(1, (healthbar_outline.Size.Y - 2) * (current_health / max_health))
                        else
                            healthbar.Position = healthbar_outline.Position + vector2_new(1, -1 + healthbar_outline.Size.Y)
                            healthbar.Size = vector2_new(1, -((healthbar_outline.Size.Y - 2) * (current_health / max_health)))
                        end
                        left_offset_x = left_offset_x + 4
                    end
                end
                healthbar.Color = c3_lerp(health_settings_bar.full_color, health_settings_bar.empty_color, 1 - current_health / max_health)
                healthbar_outline.Visible = bar_enabled
                healthbar.Visible = bar_enabled

                -- // Name
                local text_settings = esp_settings.text_settings
                local text_settings_name = text_settings.name
                local name_enabled = text_settings_name.enabled
                if name_enabled then
                    local name_position = text_settings_name.position
                    if name_position == "left" then
                        name.Position = box_position + vector2_new(-name.TextBounds.X/2 - 2 - left_offset_x, -2 + left_offset_y);
                        left_offset_y = left_offset_y + 12
                    elseif name_position == "right" then
                        name.Position = box_position + vector2_new(width + name.TextBounds.X / 2 + 2 + right_offset_x, -2 + right_offset_y);
                        right_offset_y = right_offset_y + 12
                    elseif name_position == "bottom" then
                        name.Position = box_position + vector2_new(width/2, height + bottom_offset + 1);
                        bottom_offset = bottom_offset + 13
                    else
                        name.Position = box_position + vector2_new(width/2, -15 - top_offset);
                        top_offset = top_offset + 13
                    end
                end
                name.Visible = name_enabled;

                -- // Distance
                local text_settings_distance = text_settings.distance
                local distance_enabled = text_settings_distance.enabled
                if distance_enabled then
                    local distance_position = text_settings_distance.position
                    if distance_position == "left" then
                        distance.Position = box_position + vector2_new(-distance.TextBounds.X/2 - 2 - left_offset_x, -2 + left_offset_y);
                        left_offset_y = left_offset_y + 12
                    elseif distance_position == "right" then
                        distance.Position = box_position + vector2_new(width + distance.TextBounds.X / 2 + 2 + right_offset_x, -2 + right_offset_y);
                        right_offset_y = right_offset_y + 12
                    elseif distance_position == "bottom" then
                        distance.Position = box_position + vector2_new(width/2, height + bottom_offset + 1);
                        bottom_offset = bottom_offset + 13
                    else
                        distance.Position = box_position + vector2_new(width/2, -15 - top_offset);
                        top_offset = top_offset + 13
                    end
                    if text_settings_distance.convert == "meters" then
                        distance.Text = meter_conversion .. "m"
                    else
                        distance.Text = stud_conversion .. "s"
                    end
                end
                distance.Visible = distance_enabled;

                -- // Weapon
                local text_settings_weapon = text_settings.weapon
                local weapon_enabled = text_settings_weapon.enabled
                if weapon_enabled then
                    local weapon_position = text_settings_weapon.position
                    if weapon_position == "left" then
                        weapon.Position = box_position + vector2_new(-weapon.TextBounds.X/2 - 2 - left_offset_x, -2 + left_offset_y);
                        left_offset_y = left_offset_y + 12
                    elseif weapon_position == "right" then
                        weapon.Position = box_position + vector2_new(width + weapon.TextBounds.X / 2 + 2 + right_offset_x, -2 + right_offset_y);
                        right_offset_y = right_offset_y + 12
                    elseif weapon_position == "bottom" then
                        weapon.Position = box_position + vector2_new(width/2, height + bottom_offset + 1);
                        bottom_offset = bottom_offset + 13
                    else
                        weapon.Position = box_position + vector2_new(width/2, -15 - top_offset);
                        top_offset = top_offset + 13
                    end
                end
                weapon.Visible = weapon_enabled;

                -- // Health
                local text_settings_health = text_settings.health
                local health_enabled = text_settings_health.enabled
                if health_enabled then
                    local health_position = text_settings_health.position
                    if health_position == "left" then
                        health_text.Position = box_position + vector2_new(-health_text.TextBounds.X/2 - 2 - left_offset_x, -2 + left_offset_y);
                        left_offset_y = left_offset_y + 12
                    elseif health_position == "right" then
                        health_text.Position = box_position + vector2_new(width + health_text.TextBounds.X / 2 + 2 + right_offset_x, -2 + right_offset_y);
                        right_offset_y = right_offset_y + 12
                    elseif health_position == "bottom" then
                        health_text.Position = box_position + vector2_new(width/2, height + bottom_offset + 1);
                        bottom_offset = bottom_offset + 13
                    elseif health_position == "bar" and bar_enabled then
                        if current_health < max_health then
                            health_text.Position = healthbar.Position + healthbar.Size
                        else
                            health_enabled = false
                        end
                    else
                        health_text.Position = box_position + vector2_new(width/2, -15 - top_offset);
                        top_offset = top_offset + 13
                    end
                end
                health_text.Visible = health_enabled;
            end;

            -- // Dynamic ESP
            if preciseness == 2 then
                local y_minimal, y_maximal = camera.ViewportSize.X, 0
                local x_minimal, x_maximal = camera.ViewportSize.X, 0

                for _, cf in pairs(dimensions) do
                    local Vector = camera:WorldToViewportPoint(cf.Position);
                    local x, y = Vector.X, Vector.Y;
                    if x < x_minimal then 
                        x_minimal = x;
                    end;
                    if x > x_maximal then 
                        x_maximal = x;
                    end;
                    if y < y_minimal then 
                        y_minimal = y;
                    end;
                    if y > y_maximal then
                        y_maximal = y;
                    end;
                end;

                local box_size = esp.round(vector2_new(x_minimal - x_maximal, y_minimal - y_maximal));
                local box_position = esp.round(vector2_new(x_maximal + box_size.X / x_minimal, y_maximal + box_size.Y / y_minimal));
                
                local top_offset = 3;
                local bottom_offset = y_maximal + 1;
                local left_offset_x, left_offset_y = 0, 0;
                local right_offset_x, right_offset_y = 0, 0;

                box.Position   = box_position;
                box.Size       = box_size;
                box_outline.Position  = box_position;
                box_outline.Size      = box_size;
                box_fill.Position     = box_position;
                box_fill.Size         = box_size;

                -- // Healthbar
                local health_top_size_outline    = vector2_new(box_size.X - 4, 3)
                local health_top_pos_outline     = box_position + vector2_new(2, box_size.Y - 6)
                local health_top_size_fill       = vector2_new((current_health * health_top_size_outline.X / max_health) + 2, 1)
                local health_top_pos_fill        = health_top_pos_outline + vector2_new(1 + -(health_top_size_fill.X - health_top_size_outline.X),1);

                local health_left_size_outline   = vector2_new(3, box_size.Y - 4)
                local health_left_pos_outline    = vector2_new(x_maximal + box_size.X - 6, box_position.Y + 2)
                local health_left_size_fill      = vector2_new(1, (current_health * health_left_size_outline.Y / max_health) + 2)
                local health_left_pos_fill       = health_left_pos_outline + vector2_new(1,-1 + -(health_left_size_fill.Y - health_left_size_fill.Y));

                -- // Healthbar
                local health_settings = esp_settings.health_settings;
                local health_settings_bar = health_settings.bar;
                local bar_enabled = health_settings_bar.enabled;

                if bar_enabled then
                    local healthbar_position = health_settings_bar.position
                    if healthbar_position == "left" then
                        healthbar.Size               = health_left_size_fill;
                        healthbar.Position           = health_left_pos_fill;
                        healthbar_outline.Size       = health_left_size_outline;
                        healthbar_outline.Position   = health_left_pos_outline;
                    elseif healthbar_position == "right" then
                        healthbar.Size               = health_left_size_fill;
                        healthbar.Position           = vector2_new(x_maximal + box_size.X + 4, box_position.Y + 1) - vector2_new(box_size.X, 0)
                        healthbar_outline.Size       = health_left_size_outline
                        healthbar_outline.Position   = vector2_new(x_maximal + box_size.X + 3, box_position.Y + 2) - vector2_new(box_size.X, 0)
                    elseif healthbar_position == "top" then
                        healthbar.Size               = health_top_size_fill;
                        healthbar.Position           = health_top_pos_fill;
                        healthbar_outline.Size       = health_top_size_outline;
                        healthbar_outline.Position   = health_top_pos_outline;
                        top_offset = top_offset + 6
                    elseif healthbar_position == "bottom" then
                        healthbar.Size               = health_top_size_fill
                        healthbar.Position           = health_top_pos_fill - vector2_new(0, box_size.Y - 9)
                        healthbar_outline.Size       = health_top_size_outline;
                        healthbar_outline.Position   = health_top_pos_outline - vector2_new(0, box_size.Y - 9)
                        bottom_offset = bottom_offset + 6
                    end
                end;
                healthbar.Color = c3_lerp(health_settings_bar.full_color, health_settings_bar.empty_color, 1 - current_health / max_health)
                healthbar_outline.Visible = bar_enabled
                healthbar.Visible = bar_enabled

                -- // Name
                local text_settings      = esp_settings.text_settings
                local text_settings_name = text_settings.name
                local name_enabled       = text_settings_name.enabled
                if name_enabled then
                    local name_position = text_settings_name.position
                    if name_position == "top" then 
                        name.Position    = vector2_new(x_maximal + box_size.X / 2, box_position.Y) - vector2_new(0, name.TextBounds.Y - box_size.Y + top_offset) 
                        top_offset       = top_offset + 10
                    elseif name_position == "bottom" then
                        name.Position    = vector2_new(box_size.X / 2 + box_position.X, bottom_offset) 
                        bottom_offset    = bottom_offset + 10
                    elseif name_position == "left" then
                        if health_settings_bar.position == "left" then
                            name.Position = health_left_pos_outline - vector2_new(name.TextBounds.X/2 - 2 + 4, -(100 * health_left_size_outline.Y / 100) + 2 - left_offset_x)
                        else
                            name.Position = health_left_pos_outline - vector2_new(name.TextBounds.X/2 - 2, -(100 * health_left_size_outline.Y / 100) + 2 - left_offset_x)
                        end
                        left_offset_x = left_offset_x + 10
                    elseif name_position == "right" then
                        if health_settings_bar.position == "right" then
                            name.Position = vector2_new(x_maximal + box_size.X + 4 + 4 + name.TextBounds.X / 2, box_position.Y + 2) - vector2_new(box_size.X, -(100 * health_left_size_outline.Y / 100) + 2 - right_offset_x)
                        else
                            name.Position = vector2_new(x_maximal + box_size.X + 3 + name.TextBounds.X / 2, box_position.Y + 2) - vector2_new(box_size.X, -(100 * health_left_size_outline.Y / 100) + 2 - right_offset_x)
                        end
                        right_offset_x = right_offset_x + 10
                    end
                end
                name.Visible = name_enabled;

                -- // Distance
                local text_settings_distance = text_settings.distance
                local distance_enabled       = text_settings_distance.enabled
                if distance_enabled then
                    local distance_position = text_settings_distance.position
                    if distance_position == "top" then 
                        distance.Position    = vector2_new(x_maximal + box_size.X / 2, box_position.Y) - vector2_new(0, distance.TextBounds.Y - box_size.Y + top_offset) 
                        top_offset       = top_offset + 10
                    elseif distance_position == "bottom" then
                        distance.Position    = vector2_new(box_size.X / 2 + box_position.X, bottom_offset) 
                        bottom_offset    = bottom_offset + 10
                    elseif distance_position == "left" then
                        if health_settings_bar.position == "left" then
                            distance.Position = health_left_pos_outline - vector2_new(distance.TextBounds.X/2 - 2 + 4, -(100 * health_left_size_outline.Y / 100) + 2 - left_offset_x)
                        else
                            distance.Position = health_left_pos_outline - vector2_new(distance.TextBounds.X/2 - 2, -(100 * health_left_size_outline.Y / 100) + 2 - left_offset_x)
                        end
                        left_offset_x = left_offset_x + 10
                    elseif distance_position == "right" then
                        if health_settings_bar.position == "right" then
                            distance.Position = vector2_new(x_maximal + box_size.X + 4 + 4 + distance.TextBounds.X / 2, box_position.Y + 2) - vector2_new(box_size.X, -(100 * health_left_size_outline.Y / 100) + 2 - right_offset_x)
                        else
                            distance.Position = vector2_new(x_maximal + box_size.X + 3 + distance.TextBounds.X / 2, box_position.Y + 2) - vector2_new(box_size.X, -(100 * health_left_size_outline.Y / 100) + 2 - right_offset_x)
                        end
                        right_offset_x = right_offset_x + 10
                    end
                    if text_settings_distance.convert == "meters" then
                        distance.Text = meter_conversion .. "m"
                    else
                        distance.Text = stud_conversion .. "s"
                    end
                end
                distance.Visible = distance_enabled;

                -- // Weapon
                local text_settings_weapon = text_settings.weapon
                local weapon_enabled       = text_settings_weapon.enabled
                if weapon_enabled then
                    local weapon_position = text_settings_weapon.position
                    if weapon_position == "top" then 
                        weapon.Position    = vector2_new(x_maximal + box_size.X / 2, box_position.Y) - vector2_new(0, weapon.TextBounds.Y - box_size.Y + top_offset) 
                        top_offset       = top_offset + 10
                    elseif weapon_position == "bottom" then
                        weapon.Position    = vector2_new(box_size.X / 2 + box_position.X, bottom_offset) 
                        bottom_offset    = bottom_offset + 10
                    elseif weapon_position == "left" then
                        if health_settings_bar.position == "left" then
                            weapon.Position = health_left_pos_outline - vector2_new(weapon.TextBounds.X/2 - 2 + 4, -(100 * health_left_size_outline.Y / 100) + 2 - left_offset_x)
                        else
                            weapon.Position = health_left_pos_outline - vector2_new(weapon.TextBounds.X/2 - 2, -(100 * health_left_size_outline.Y / 100) + 2 - left_offset_x)
                        end
                        left_offset_x = left_offset_x + 10
                    elseif weapon_position == "right" then
                        if health_settings_bar.position == "right" then
                            weapon.Position = vector2_new(x_maximal + box_size.X + 4 + 4 + weapon.TextBounds.X / 2, box_position.Y + 2) - vector2_new(box_size.X, -(100 * health_left_size_outline.Y / 100) + 2 - right_offset_x)
                        else
                            weapon.Position = vector2_new(x_maximal + box_size.X + 3 + weapon.TextBounds.X / 2, box_position.Y + 2) - vector2_new(box_size.X, -(100 * health_left_size_outline.Y / 100) + 2 - right_offset_x)
                        end
                        right_offset_x = right_offset_x + 10
                    end
                end
                weapon.Visible = weapon_enabled;

                -- // Health
                local text_settings_health = text_settings.health
                local health_enabled       = text_settings_health.enabled
                if health_enabled then
                    local health_position = text_settings_health.position
                    if health_position == "top" then 
                        health_text.Position    = vector2_new(x_maximal + box_size.X / 2, box_position.Y) - vector2_new(0, health_text.TextBounds.Y - box_size.Y + top_offset) 
                        top_offset       = top_offset + 10
                    elseif health_position == "bottom" then
                        health_text.Position    = vector2_new(box_size.X / 2 + box_position.X, bottom_offset) 
                        bottom_offset    = bottom_offset + 10
                    elseif health_position == "left" then
                        if health_settings_bar.position == "left" then
                            health_text.Position = health_left_pos_outline - vector2_new(health_text.TextBounds.X/2 - 2 + 4, -(100 * health_left_size_outline.Y / 100) + 2 - left_offset_x)
                        else
                            health_text.Position = health_left_pos_outline - vector2_new(health_text.TextBounds.X/2 - 2, -(100 * health_left_size_outline.Y / 100) + 2 - left_offset_x)
                        end
                        left_offset_x = left_offset_x + 10
                    elseif health_position == "right" then
                        if health_settings_bar.position == "right" then
                            health_text.Position = vector2_new(x_maximal + box_size.X + 4 + 4 + health_text.TextBounds.X / 2, box_position.Y + 2) - vector2_new(box_size.X, -(100 * health_left_size_outline.Y / 100) + 2 - right_offset_x)
                        else
                            health_text.Position = vector2_new(x_maximal + box_size.X + 3 + health_text.TextBounds.X / 2, box_position.Y + 2) - vector2_new(box_size.X, -(100 * health_left_size_outline.Y / 100) + 2 - right_offset_x)
                        end
                        right_offset_x = right_offset_x + 10
                    elseif health_position == "bar" then
                        if current_health < max_health then
                            health_text.Position = healthbar.Position + healthbar.Size
                        else
                            health_enabled = false
                        end
                    end
                end
                health_text.Visible = weapon_enabled;
            end;

            -- // chameleon
            local chams_settings = esp_settings.chameleon;
            local chams_enabled  = chams_settings.enabled;

            chameleon.Enabled = chams_enabled
            chameleon.Adornee = chams_enabled and character or nil
            if chams_enabled then
                chameleon.FillColor           = chams_settings.color;
                chameleon.OutlineColor        = chams_settings.outline_color;
                chameleon.FillTransparency    = chams_settings.transparency;
                chameleon.OutlineTransparency = chams_settings.outline_transparency;
            end;

            -- // highlight
            local highlight_settings  = esp_settings.highlight;
            local is_highlighted      = highlight_settings.enabled and highlight_settings.target == plr or false
            local highlight_color     = highlight_settings.color;

            -- // name component
            name.Text          = plr.Name;
            name.Size          = esp_settings.font_size;
            name.Font          = esp_settings.font;
            name.Color         = is_highlighted and highlight_color or esp_settings.text_settings.name.color;
            name.OutlineColor  = esp_settings.text_settings.name.color_outline;

            -- // distance component
            distance.Size           = esp_settings.font_size;
            distance.Font           = esp_settings.font;
            distance.Color          = is_highlighted and highlight_color or esp_settings.text_settings.distance.color;
            distance.OutlineColor   = esp_settings.text_settings.distance.color_outline;

            -- // weapon component
            weapon.Size           = esp_settings.font_size;
            weapon.Font           = esp_settings.font;
            weapon.Color          = is_highlighted and highlight_color or esp_settings.text_settings.weapon.color;
            weapon.OutlineColor   = esp_settings.text_settings.weapon.color_outline;
            weapon.Text           = esp_get_tool(plr, character);

            -- // health component
            health_text.Size           = esp_settings.font_size;
            health_text.Font           = esp_settings.font;
            health_text.Color          = healthbar.Color;
            health_text.OutlineColor   = esp_settings.text_settings.health.color_outline;
            health_text.Text           = tostring(math_floor(current_health));

            -- // box component
            box.Color              = is_highlighted and highlight_color or esp_settings.box.color;
            box.Visible            = esp_settings.box.enabled;

            box_fill.Color         = is_highlighted and highlight_color or esp_settings.box_fill.color;
            box_fill.Visible       = esp_settings.box_fill.enabled;
            box_fill.Transparency  = esp_settings.box_fill.transparency;

            box_outline.Color      = esp_settings.box.color_outline;
            box_outline.Visible    = esp_settings.box.enabled;
        end;
    end;


    -- // Connections
    for i, v in pairs(players:GetPlayers()) do 
        esp.add(v);
    end;
    utility_connection(players.PlayerAdded, esp.add);
    utility_connection(players.PlayerRemoving, esp.remove);
end;

getgenv().esp = esp
return esp
