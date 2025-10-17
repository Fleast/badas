-- Instances: 147 | Scripts: 0 | Modules: 1
local DRR = {};

-- DrRay
DRR["1"] = Instance.new("ScreenGui", game:GetService("CoreGui"));
DRR["1"]["IgnoreGuiInset"] = true;
DRR["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
DRR["1"]["Name"] = [[DrRay]];
DRR["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

-- DrRay.TopBar
DRR["2"] = Instance.new("Frame", DRR["1"]);
DRR["2"]["BorderSizePixel"] = 0;
DRR["2"]["BackgroundColor3"] = Color3.fromRGB(28, 57, 43); -- Diubah
DRR["2"]["BackgroundTransparency"] = 0.15; -- Ditambahkan
DRR["2"]["LayoutOrder"] = 2;
DRR["2"]["Size"] = UDim2.new(0.5404488444328308, 0, 0.1739015281200409, 0);
DRR["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["2"]["Position"] = UDim2.new(0.23000000417232513, 0, -0.1899999976158142, 0);
DRR["2"]["Name"] = [[TopBar]];

-- DrRay.TopBar.UICorner
DRR["3"] = Instance.new("UICorner", DRR["2"]);
DRR["3"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

-- DrRay.TopBar.ScrollingFrame
DRR["4"] = Instance.new("ScrollingFrame", DRR["2"]);
DRR["4"]["Active"] = true;
DRR["4"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
DRR["4"]["BorderSizePixel"] = 0;
DRR["4"]["CanvasSize"] = UDim2.new(0.10000000149011612, 0, 0, 0);
DRR["4"]["BackgroundColor3"] = Color3.fromRGB(20, 40, 30); -- Diubah
DRR["4"]["AutomaticCanvasSize"] = Enum.AutomaticSize.X;
DRR["4"]["BackgroundTransparency"] = 1;
DRR["4"]["Size"] = UDim2.new(0.915977954864502, 0, 0.5196850299835205, 0);
DRR["4"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
DRR["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["4"]["ScrollBarThickness"] = 0;
DRR["4"]["Position"] = UDim2.new(0, 0, 0.4803149700164795, 0);

-- DrRay.TopBar.ScrollingFrame.UIListLayout
DRR["5"] = Instance.new("UIListLayout", DRR["4"]);
DRR["5"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
DRR["5"]["FillDirection"] = Enum.FillDirection.Horizontal;
DRR["5"]["Padding"] = UDim.new(0.009999999776482582, 0);
DRR["5"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- DrRay.TopBar.ScrollingFrame.UIPadding
DRR["6"] = Instance.new("UIPadding", DRR["4"]);
DRR["6"]["PaddingLeft"] = UDim.new(0.014999999664723873, 0);

-- DrRay.TopBar.DropShadowHolder
DRR["7"] = Instance.new("Frame", DRR["2"]);
DRR["7"]["ZIndex"] = 0;
DRR["7"]["BorderSizePixel"] = 0;
DRR["7"]["BackgroundTransparency"] = 1;
DRR["7"]["Size"] = UDim2.new(1, 0, 1, 0);
DRR["7"]["Name"] = [[DropShadowHolder]];

-- DrRay.TopBar.DropShadowHolder.DropShadow
DRR["8"] = Instance.new("ImageLabel", DRR["7"]);
DRR["8"]["ZIndex"] = 0;
DRR["8"]["BorderSizePixel"] = 0;
DRR["8"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
DRR["8"]["ScaleType"] = Enum.ScaleType.Slice;
DRR["8"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
DRR["8"]["ImageTransparency"] = 0.5;
DRR["8"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DRR["8"]["Image"] = [[rbxassetid://6014261993]];
DRR["8"]["Size"] = UDim2.new(1, 47, 1, 47);
DRR["8"]["Name"] = [[DropShadow]];
DRR["8"]["BackgroundTransparency"] = 1;
DRR["8"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

-- DrRay.TopBar.UIGradient
DRR["9"] = Instance.new("UIGradient", DRR["2"]);
DRR["9"]["Rotation"] = 90;
DRR["9"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(74, 93, 83)), ColorSequenceKeypoint.new(1.000, Color3.fromRGB(119, 141, 129))}; -- Diubah

-- DrRay.TopBar.TopBar
DRR["a"] = Instance.new("Frame", DRR["2"]);
DRR["a"]["BorderSizePixel"] = 0;
DRR["a"]["BackgroundColor3"] = Color3.fromRGB(28, 57, 43); -- Diubah
DRR["a"]["LayoutOrder"] = 2;
DRR["a"]["Size"] = UDim2.new(0.9983566999435425, 0, 0.05511785298585892, 0);
DRR["a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["a"]["Position"] = UDim2.new(0, 0, 0.4645671844482422, 0);
DRR["a"]["Name"] = [[TopBar]];

-- DrRay.TopBar.TopBar.UIGradient
DRR["b"] = Instance.new("UIGradient", DRR["a"]);
DRR["b"]["Rotation"] = -90;
DRR["b"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(74, 93, 83)), ColorSequenceKeypoint.new(1.000, Color3.fromRGB(119, 141, 129))}; -- Diubah

-- DrRay.TopBar.ProfileMenu
DRR["c"] = Instance.new("Frame", DRR["2"]);
DRR["c"]["BorderSizePixel"] = 0;
DRR["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DRR["c"]["BackgroundTransparency"] = 1;
DRR["c"]["Size"] = UDim2.new(0.9983566999435425, 0, 0.4645672142505646, 0);
DRR["c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["c"]["Name"] = [[ProfileMenu]];

-- DrRay.TopBar.ProfileMenu.PlayerProfile
DRR["d"] = Instance.new("ImageButton", DRR["c"]);
DRR["d"]["BorderSizePixel"] = 0;
DRR["d"]["AutoButtonColor"] = false;
DRR["d"]["BackgroundColor3"] = Color3.fromRGB(28, 57, 43); -- Diubah
DRR["d"]["Size"] = UDim2.new(0.23481373488903046, 0, 0.682426393032074, 0);
DRR["d"]["Name"] = [[PlayerProfile]];
DRR["d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["d"]["Position"] = UDim2.new(0.015024710446596146, 0, 0.18421050906181335, 0);

-- DrRay.TopBar.ProfileMenu.PlayerProfile.UICorner
DRR["e"] = Instance.new("UICorner", DRR["d"]);
DRR["e"]["CornerRadius"] = UDim.new(0.30000001192092896, 0);

-- DrRay.TopBar.ProfileMenu.PlayerProfile.UIGradient
DRR["f"] = Instance.new("UIGradient", DRR["d"]);
DRR["f"]["Rotation"] = 90;
DRR["f"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(74, 93, 83)), ColorSequenceKeypoint.new(1.000, Color3.fromRGB(119, 141, 129))}; -- Diubah

-- DrRay.TopBar.ProfileMenu.PlayerProfile.ImageLabel
DRR["10"] = Instance.new("ImageLabel", DRR["d"]);
DRR["10"]["BorderSizePixel"] = 0;
DRR["10"]["BackgroundColor3"] = Color3.fromRGB(28, 57, 43); -- Diubah
DRR["10"]["Size"] = UDim2.new(0.16644950211048126, 0, 0.8032786846160889, 0);
DRR["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["10"]["Position"] = UDim2.new(0.03799999877810478, 0, 0.1420000046491623, 0);

-- DrRay.TopBar.ProfileMenu.PlayerProfile.ImageLabel.UIAspectRatioConstraint
DRR["11"] = Instance.new("UIAspectRatioConstraint", DRR["10"]);
DRR["11"]["AspectRatio"] = 0.9842342734336853;

-- DrRay.TopBar.ProfileMenu.PlayerProfile.ImageLabel.UICorner
DRR["12"] = Instance.new("UICorner", DRR["10"]);
DRR["12"]["CornerRadius"] = UDim.new(100, 0);

-- DrRay.TopBar.ProfileMenu.PlayerProfile.ImageLabel.UIGradient
DRR["13"] = Instance.new("UIGradient", DRR["10"]);
DRR["13"]["Rotation"] = 90;
DRR["13"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(119, 141, 129)), ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 255, 255))}; -- Diubah

-- DrRay.TopBar.ProfileMenu.PlayerProfile.TextLabel
DRR["14"] = Instance.new("TextLabel", DRR["d"]);
DRR["14"]["TextWrapped"] = true;
DRR["14"]["BorderSizePixel"] = 0;
DRR["14"]["TextScaled"] = true;
DRR["14"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DRR["14"]["TextXAlignment"] = Enum.TextXAlignment.Left;
DRR["14"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
DRR["14"]["TextSize"] = 14;
DRR["14"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DRR["14"]["AutomaticSize"] = Enum.AutomaticSize.X;
DRR["14"]["Size"] = UDim2.new(0.7192937135696411, 0, 0.41530051827430725, 0);
DRR["14"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["14"]["Text"] = [[PlayerName]];
DRR["14"]["BackgroundTransparency"] = 1;
DRR["14"]["Position"] = UDim2.new(0.23957718908786774, 0, 0.27320244908332825, 0);

-- DrRay.TopBar.ProfileMenu.UIListLayout
DRR["15"] = Instance.new("UIListLayout", DRR["c"]);
DRR["15"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
DRR["15"]["FillDirection"] = Enum.FillDirection.Horizontal;
DRR["15"]["Padding"] = UDim.new(0.014999999664723873, 0);
DRR["15"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- DrRay.TopBar.ProfileMenu.UIPadding
DRR["16"] = Instance.new("UIPadding", DRR["c"]);
DRR["16"]["PaddingLeft"] = UDim.new(0.014000000432133675, 0);

-- DrRay.TopBar.ProfileMenu.Clock
DRR["17"] = Instance.new("ImageButton", DRR["c"]);
DRR["17"]["BorderSizePixel"] = 0;
DRR["17"]["AutoButtonColor"] = false;
DRR["17"]["BackgroundColor3"] = Color3.fromRGB(28, 57, 43); -- Diubah
DRR["17"]["Size"] = UDim2.new(0.10328257083892822, 0, 0.682426393032074, 0);
DRR["17"]["Name"] = [[Clock]];
DRR["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["17"]["Position"] = UDim2.new(0.26031631231307983, 0, 0.158786803483963, 0);

-- DrRay.TopBar.ProfileMenu.Clock.UICorner
DRR["18"] = Instance.new("UICorner", DRR["17"]);
DRR["18"]["CornerRadius"] = UDim.new(0.30000001192092896, 0);

-- DrRay.TopBar.ProfileMenu.Clock.UIGradient
DRR["19"] = Instance.new("UIGradient", DRR["17"]);
DRR["19"]["Rotation"] = 90;
DRR["19"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(74, 93, 83)), ColorSequenceKeypoint.new(1.000, Color3.fromRGB(119, 141, 129))}; -- Diubah

-- DrRay.TopBar.ProfileMenu.Clock.TextLabel
DRR["1a"] = Instance.new("TextLabel", DRR["17"]);
DRR["1a"]["TextWrapped"] = true;
DRR["1a"]["BorderSizePixel"] = 0;
DRR["1a"]["TextScaled"] = true;
DRR["1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DRR["1a"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
DRR["1a"]["TextSize"] = 14;
DRR["1a"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DRR["1a"]["AutomaticSize"] = Enum.AutomaticSize.X;
DRR["1a"]["Size"] = UDim2.new(0.33195531368255615, 0, 0.41530051827430725, 0);
DRR["1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["1a"]["Text"] = [[00:00]];
DRR["1a"]["BackgroundTransparency"] = 1;
DRR["1a"]["Position"] = UDim2.new(0.21512815356254578, 0, 0.27320244908332825, 0);

-- DrRay.TopBar.ProfileMenu.Title
DRR["1b"] = Instance.new("ImageButton", DRR["c"]);
DRR["1b"]["BorderSizePixel"] = 0;
DRR["1b"]["AutoButtonColor"] = false;
DRR["1b"]["BackgroundColor3"] = Color3.fromRGB(28, 57, 43); -- Diubah
DRR["1b"]["Size"] = UDim2.new(0.23481373488903046, 0, 0.682426393032074, 0);
DRR["1b"]["Name"] = [[Title]];
DRR["1b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["1b"]["Position"] = UDim2.new(0.015024710446596146, 0, 0.18421050906181335, 0);

-- DrRay.TopBar.ProfileMenu.Title.UICorner
DRR["1c"] = Instance.new("UICorner", DRR["1b"]);
DRR["1c"]["CornerRadius"] = UDim.new(0.30000001192092896, 0);

-- DrRay.TopBar.ProfileMenu.Title.UIGradient
DRR["1d"] = Instance.new("UIGradient", DRR["1b"]);
DRR["1d"]["Rotation"] = 90;
DRR["1d"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(74, 93, 83)), ColorSequenceKeypoint.new(1.000, Color3.fromRGB(119, 141, 129))}; -- Diubah

-- DrRay.TopBar.ProfileMenu.Title.TextLabel
DRR["1e"] = Instance.new("TextLabel", DRR["1b"]);
DRR["1e"]["
