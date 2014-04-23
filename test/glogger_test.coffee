"use strict"

glogger = require "../lib/glogger.js"
oGlogger = null

# =============================================================================

exports[ 'Default Glogger' ] =
    'setUp': ( done ) ->
        oGlogger = glogger()
        done()

    'exists': ( test ) ->
        test.expect 2
        test.equal oGlogger.ERROR, 1, "ERROR level must be 1."
        test.equal oGlogger.VERBOSE, 256, "VERBOSE level must be 256."

        test.done()

    'default context': ( test ) ->
        test.expect 1
        test.equal oGlogger.getContext(), "", "Context must be empty at start."
        test.done()

    'default level': ( test ) ->
        test.expect 1
        test.equal oGlogger.getLevel(), oGlogger.INFO, "Default level must be INFO."
        test.done()

exports[ 'Initialized Glogger' ] =
    'test with specified Level': ( test ) ->
        sLevel = "ERROR"

        oGlogger = glogger
            level: sLevel

        test.expect 1
        test.equal oGlogger.getLevel(), oGlogger.ERROR, "Specified level must be #{ sLevel } : #{ oGlogger.ERROR }."
        test.done()

    'test with specified Context': ( test ) ->
        sContext = "Glogger Test"
        oGlogger = glogger
            context: sContext

        test.expect 1
        test.equal oGlogger.getContext(), sContext, "Specified level must be #{ sContext }."
        test.done()


