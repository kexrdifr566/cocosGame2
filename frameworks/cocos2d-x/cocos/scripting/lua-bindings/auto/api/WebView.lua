
--------------------------------
-- @module WebView
-- @extend Widget
-- @parent_module ccexp

--------------------------------
-- Call before a web view begins loading.<br>
-- param callback The web view that is about to load new content.<br>
-- return YES if the web view should begin loading content; otherwise, NO.
-- @function [parent=#WebView] setOnShouldStartLoading 
-- @param self
-- @param #function callback
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- SetOpacity of webview.
-- @function [parent=#WebView] setOpacityWebView 
-- @param self
-- @param #float opacity
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Call if a web view failed to load content.<br>
-- param callback The web view that has failed loading.
-- @function [parent=#WebView] setOnDidFailLoading 
-- @param self
-- @param #function callback
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Gets whether this WebView has a back history item.<br>
-- return WebView has a back history item.
-- @function [parent=#WebView] canGoBack 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- Sets the main page content and base URL.<br>
-- param string The content for the main page.<br>
-- param baseURL The base URL for the content.
-- @function [parent=#WebView] loadHTMLString 
-- @param self
-- @param #string string
-- @param #string baseURL
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Goes forward in the history.
-- @function [parent=#WebView] goForward 
-- @param self
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Goes back in the history.
-- @function [parent=#WebView] goBack 
-- @param self
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Set WebView should support zooming. The default value is false.
-- @function [parent=#WebView] setScalesPageToFit 
-- @param self
-- @param #bool scalesPageToFit
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Get the callback when WebView has failed loading.
-- @function [parent=#WebView] getOnDidFailLoading 
-- @param self
-- @return function#function ret (return value: function)
        
--------------------------------
-- Loads the given fileName.<br>
-- param fileName Content fileName.
-- @function [parent=#WebView] loadFile 
-- @param self
-- @param #string fileName
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- @overload self, string, bool         
-- @overload self, string         
-- @function [parent=#WebView] loadURL
-- @param self
-- @param #string url
-- @param #bool cleanCachedData
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)

--------------------------------
-- Set whether the webview bounces at end of scroll of WebView.
-- @function [parent=#WebView] setBounces 
-- @param self
-- @param #bool bounce
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Evaluates JavaScript in the context of the currently displayed page.
-- @function [parent=#WebView] evaluateJS 
-- @param self
-- @param #string js
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- This callback called when load URL that start with javascript interface scheme.
-- @function [parent=#WebView] setOnJSCallback 
-- @param self
-- @param #function callback
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- set the background transparent
-- @function [parent=#WebView] setBackgroundTransparent 
-- @param self
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Get the Javascript callback.
-- @function [parent=#WebView] getOnJSCallback 
-- @param self
-- @return function#function ret (return value: function)
        
--------------------------------
-- Gets whether this WebView has a forward history item.<br>
-- return WebView has a forward history item.
-- @function [parent=#WebView] canGoForward 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- Get the callback when WebView is about to start.
-- @function [parent=#WebView] getOnShouldStartLoading 
-- @param self
-- @return function#function ret (return value: function)
        
--------------------------------
-- Stops the current load.
-- @function [parent=#WebView] stopLoading 
-- @param self
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- getOpacity of webview.
-- @function [parent=#WebView] getOpacityWebView 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- Reloads the current URL.
-- @function [parent=#WebView] reload 
-- @param self
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Set javascript interface scheme.<br>
-- see WebView::setOnJSCallback()
-- @function [parent=#WebView] setJavascriptInterfaceScheme 
-- @param self
-- @param #string scheme
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Call after a web view finishes loading.<br>
-- param callback The web view that has finished loading.
-- @function [parent=#WebView] setOnDidFinishLoading 
-- @param self
-- @param #function callback
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Get the callback when WebView has finished loading.
-- @function [parent=#WebView] getOnDidFinishLoading 
-- @param self
-- @return function#function ret (return value: function)
        
--------------------------------
-- Allocates and initializes a WebView.
-- @function [parent=#WebView] create 
-- @param self
-- @return experimental::ui::WebView#experimental::ui::WebView ret (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- 
-- @function [parent=#WebView] onEnter 
-- @param self
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Toggle visibility of WebView.
-- @function [parent=#WebView] setVisible 
-- @param self
-- @param #bool visible
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- 
-- @function [parent=#WebView] onExit 
-- @param self
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
--------------------------------
-- Default constructor.
-- @function [parent=#WebView] WebView 
-- @param self
-- @return experimental::ui::WebView#experimental::ui::WebView self (return value: cc.experimental::ui::WebView)
        
return nil
