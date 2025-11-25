Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyBase

# Создаем окно
$window = New-Object System.Windows.Window
$window.WindowStyle = "None"
$window.WindowState = "Maximized"
$window.Topmost = $true
$window.Background = "Black"
$window.ResizeMode = "NoResize"

# Сетка
$grid = New-Object System.Windows.Controls.Grid
$window.Content = $grid

# Холст для анимации "матрицы"
$canvas = New-Object System.Windows.Controls.Canvas
$grid.Children.Add($canvas) | Out-Null

# Текст на панели
$text = New-Object System.Windows.Controls.TextBlock
$text.Text = "ваш компик заблокирован by кошкодевочка"
$text.FontSize = 44
$text.FontFamily = "Consolas"
$text.FontWeight = "Bold"
$text.HorizontalAlignment = "Center"
$text.VerticalAlignment = "Center"   # текст по центру панели
$text.TextAlignment = "Center"

# Неоновая панель
$border = New-Object System.Windows.Controls.Border
$border.BorderBrush = "HotPink"
$border.BorderThickness = 4
$border.CornerRadius = [System.Windows.CornerRadius]::new(15)
$border.Padding = [System.Windows.Thickness]::new(20)
$border.Child = $text
$border.HorizontalAlignment = "Center"
$border.VerticalAlignment = "Top"     # панель в верхней части окна
$border.Margin = "0,50,0,0"           # отступ сверху
$border.Effect = New-Object System.Windows.Media.Effects.DropShadowEffect
$border.Effect.Color = [System.Windows.Media.Colors]::Magenta
$border.Effect.ShadowDepth = 0
$border.Effect.BlurRadius = 25

$grid.Children.Add($border) | Out-Null

# Текст подсказки
$hint = New-Object System.Windows.Controls.TextBlock
$hint.Text = "Введите пароль для разблокировки и удаления локеров"
$hint.FontSize = 22
$hint.FontFamily = "Consolas"
$hint.FontWeight = "Bold"
$hint.Foreground = "Cyan"
$hint.HorizontalAlignment = "Center"
$hint.VerticalAlignment = "Center"
$hint.Margin = "0,180,0,0"  # чуть ниже панели
$grid.Children.Add($hint) | Out-Null

# Поле ввода пароля
$box = New-Object System.Windows.Controls.TextBox
$box.Width = 400
$box.Height = 42
$box.FontSize = 24
$box.FontFamily = "Consolas"
$box.Background = "#0F0F0F"
$box.Foreground = "Lime"
$box.BorderBrush = "Cyan"
$box.BorderThickness = 2
$box.HorizontalAlignment = "Center"
$box.VerticalAlignment = "Center"
$box.Margin = "0,240,0,0"  # под подсказкой
$grid.Children.Add($box) | Out-Null

# Статус под полем
$status = New-Object System.Windows.Controls.TextBlock
$status.Text = ""
$status.FontSize = 22
$status.Foreground = "Red"
$status.HorizontalAlignment = "Center"
$status.VerticalAlignment = "Center"
$status.Margin = "0,300,0,0"  # немного увеличено расстояние
$grid.Children.Add($status) | Out-Null

# Функция генерации случайной строки
function RandomLine {
    $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
    -join ((1..60) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
}

# Матричные линии
$height = [System.Windows.SystemParameters]::PrimaryScreenHeight
$width = [System.Windows.SystemParameters]::PrimaryScreenWidth
$lines = @()

for ($i = 0; $i -lt 30; $i++) {
    $line = New-Object System.Windows.Controls.TextBlock
    $line.Text = RandomLine
    $line.FontSize = 20
    $line.FontFamily = "Consolas"
    $line.Foreground = "Lime"
    $line.Opacity = 0.6
    $left = Get-Random -Minimum 0 -Maximum ($width - 800)
    $top = Get-Random -Minimum 0 -Maximum $height
    [System.Windows.Controls.Canvas]::SetTop($line, $top)
    [System.Windows.Controls.Canvas]::SetLeft($line, $left)
    $canvas.Children.Add($line) | Out-Null
    $lines += $line
}

# Анимация матрицы
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromMilliseconds(70)
$timer.Add_Tick({
    foreach ($line in $lines) {
        $line.Text = RandomLine
        $top = [System.Windows.Controls.Canvas]::GetTop($line)
        $top += 6
        if ($top -gt $height) { $top = -20 }
        [System.Windows.Controls.Canvas]::SetTop($line, $top)
    }
    # Неоновый эффект текста — перелив
    $r = 255
    $g = 0
    $b = Get-Random -Minimum 150 -Maximum 255
    $text.Foreground = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Color]::FromRgb($r,$g,$b))
})
$timer.Start()

# Обработка "пароля"
$box.Add_KeyDown({
    if ($_.Key -eq "Enter") {
        if ($box.Text -eq "xvFJsdfksIHHDmfk49") {
            $window.Close()
        } else {
            $status.Text = "пароль неверный, доступ разрешён только кошкодевочкам"
        }
    }
})

# ESC = закрыть
$window.Add_KeyDown({
    if ($_.Key -eq "Escape") { $window.Close() }
})

$window.ShowDialog() | Out-Null
