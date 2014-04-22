###
 * Glogger - Simple global logger for Node
 *
 * Copyright (c) 2014 Thierry 'Akarun' Lagasse
 * Licensed under the MIT license.
###
"use strict"

clc = require "cli-color"

# =============================================================================
# Logger Class
class Glogger
    ERROR: 1        # red
    WARNING: 2      # yellow
    INFO: 4         # green
    DEBUG: 8        # blackBright
    VERBOSE: 256    # white

    # -------------------------------------------------------------------------

    constructor: ( mConfig ) ->
        @_sContext = oGlobalLogger?.getContext() or ""
        @_iLevel = oGlobalLogger?.getLevel() or @INFO

        switch typeof mConfig
            when "number" then @_iLevel = mConfig

            when "string"
                iLevel = @levelFromString mConfig
                if iLevel
                    @_iLevel = iLevel
                else
                    @_sContext = mConfig or ""

            when "object"
                @_sContext = mConfig.context if mConfig.context
                @_iLevel = switch typeof mConfig.level
                    when "string" then @levelFromString mConfig.level, @INFO
                    when "number" then mConfig.level
                    else @_iLevel

    # -------------------------------------------------------------------------

    getContext: ->
        @_sContext

    getLevel: ->
        @_iLevel

    levelFromString: ( sLevel, iDefault = false ) ->
        { error: 1, warning: 2, info: 4, debug: 8, verbose: 256 }[ sLevel.toLowerCase() ] or iDefault

    # -------------------------------------------------------------------------

    log: ( sMessage, sContext = @_sContext, iLevel = @_iLevel ) ->
        if iLevel <= @_iLevel
            dDate = new Date()
            sDay = ( "00" + dDate.getDate() )[-2..]
            sMonth = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ][ dDate.getMonth() ]
            sHours = ( "00" + dDate.getHours() )[-2..]
            sMinutes = ( "00" + dDate.getMinutes() )[-2..]
            sSeconds = ( "00" + dDate.getSeconds() )[-2..]
            sDate = "#{ sDay } #{ sMonth } #{ sHours }:#{ sMinutes }:#{ sSeconds }"

            sMessage = "[#{ sContext }] #{ sMessage }" if sContext

            sMessage = switch iLevel
                when @ERROR    then clc.red.bold( sMessage )
                when @WARNING  then clc.yellow( sMessage )
                when @INFO     then clc.green( sMessage )
                when @DEBUG    then clc.blackBright( sMessage )
                else           clc.blackBright( sMessage )

            console.log "#{ sDate } #{ sMessage }"

    # -------------------------------------------------------------------------

    verbose: ( sMessage, sContext = @_sContext ) ->
        @log sMessage, sContext, @VERBOSE

    debug: ( sMessage, sContext = @_sContext ) ->
        @log sMessage, sContext, @DEBUG

    info: ( sMessage, sContext = @_sContext ) ->
        @log sMessage, sContext, @INFO

    warning: ( sMessage, sContext = @_sContext ) ->
        @log sMessage, sContext, @WARNING

    error: ( sMessage, sContext = @_sContext ) ->
        @log sMessage, sContext, @ERROR


# =============================================================================
# Logger Factory

oGlobalLogger = null
factoryLogger = ( mConfig ) ->
    oLogger = new Glogger mConfig
    oGlobalLogger ?= oLogger
    oLogger

module.exports = factoryLogger
