local WidgetContainer = require("ui/widget/container/widgetcontainer")
local UIManager = require("ui/uimanager")
local Icons = require("modules/ui/icons")
local Dispatcher = require("dispatcher")
local ffiutil = require("ffi/util")
local _ = require("gettext")

local QuickRSS = WidgetContainer:extend{
    name = "quickrss",
    is_doc_only = false
}

function QuickRSS:onDispatcherRegisterActions()
    Dispatcher:registerAction("quickrss_open", {
        category = "none",
        event = "QuickRSSOpen",
        title = _("Open QuickRSS"),
        general = true
    })
end

function QuickRSS:onQuickRSSOpen()
    local QuickRSSUI = require("modules/ui/feed_view")
    local instance = QuickRSSUI:new{}
    instance.filter_unread = true
    instance:_updateFilterButton()
    instance:_applyFilter()
    UIManager:show(instance)
    UIManager:nextTick(function()
        ffiutil.sleep(1)
        instance:_fetch()
    end)
    return true
end

function QuickRSS:init()
    self:onDispatcherRegisterActions()

    if self.ui and self.ui.menu then
        self.ui.menu:registerToMainMenu(self)
    end
end

function QuickRSS:addToMainMenu(menu_items)
    menu_items.quickrss = {
        text = Icons.FEEDS .. " " .. _("QuickRSS"),
        sorting_hint = "search",
        callback = function()
            self:onQuickRSSOpen()
        end
    }
end

return QuickRSS
