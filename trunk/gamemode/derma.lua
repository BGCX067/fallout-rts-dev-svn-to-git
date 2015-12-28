local PipIconButton = {}
PipIconButton.Color = Color(0, 230, 0)

function PipIconButton:PerformLayout()
	self:SetTextColor(Color(255, 255, 255, 255))
end

function PipIconButton:OnCursorEntered()
	self.Color = Color(0, 150, 0)
end

function PipIconButton:OnCursorExited()
	self.Color = Color(0, 230, 0)
end

function PipIconButton:OnMousePressed()
	self.Color = Color(0, 100, 0)
end

function PipIconButton:OnMouseReleased()
	self.Color = Color(0, 230, 0)
	self:DoClick()
end

function PipIconButton:Paint()
	draw.RoundedBox(0, 2, 2, self:GetWide() - 4, self:GetTall() - 4, self.Color)
end

vgui.Register("PipIconButton", PipIconButton, "DButton")