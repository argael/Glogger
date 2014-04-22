
/*
 * Glogger - Simple global logger for Node
 *
 * Copyright (c) 2014 Thierry 'Akarun' Lagasse
 * Licensed under the MIT license.
 */
"use strict";
var Glogger, clc, factoryLogger, oGlobalLogger;

clc = require("cli-color");

Glogger = (function() {
  Glogger.prototype.ERROR = 1;

  Glogger.prototype.WARNING = 2;

  Glogger.prototype.INFO = 4;

  Glogger.prototype.DEBUG = 8;

  Glogger.prototype.VERBOSE = 256;

  function Glogger(mConfig) {
    var iLevel;
    this._sContext = (typeof oGlobalLogger !== "undefined" && oGlobalLogger !== null ? oGlobalLogger.getContext() : void 0) || "";
    this._iLevel = (typeof oGlobalLogger !== "undefined" && oGlobalLogger !== null ? oGlobalLogger.getLevel() : void 0) || this.INFO;
    switch (typeof mConfig) {
      case "number":
        this._iLevel = mConfig;
        break;
      case "string":
        iLevel = this.levelFromString(mConfig);
        if (iLevel) {
          this._iLevel = iLevel;
        } else {
          this._sContext = mConfig || "";
        }
        break;
      case "object":
        if (mConfig.context) {
          this._sContext = mConfig.context;
        }
        this._iLevel = (function() {
          switch (typeof mConfig.level) {
            case "string":
              return this.levelFromString(mConfig.level, this.INFO);
            case "number":
              return mConfig.level;
            default:
              return this._iLevel;
          }
        }).call(this);
    }
  }

  Glogger.prototype.getContext = function() {
    return this._sContext;
  };

  Glogger.prototype.getLevel = function() {
    return this._iLevel;
  };

  Glogger.prototype.levelFromString = function(sLevel, iDefault) {
    if (iDefault == null) {
      iDefault = false;
    }
    return {
      error: 1,
      warning: 2,
      info: 4,
      debug: 8,
      verbose: 256
    }[sLevel.toLowerCase()] || iDefault;
  };

  Glogger.prototype.log = function(sMessage, sContext, iLevel) {
    var dDate, sDate, sDay, sHours, sMinutes, sMonth, sSeconds;
    if (sContext == null) {
      sContext = this._sContext;
    }
    if (iLevel == null) {
      iLevel = this._iLevel;
    }
    if (iLevel <= this._iLevel) {
      dDate = new Date();
      sDay = ("00" + dDate.getDate()).slice(-2);
      sMonth = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][dDate.getMonth()];
      sHours = ("00" + dDate.getHours()).slice(-2);
      sMinutes = ("00" + dDate.getMinutes()).slice(-2);
      sSeconds = ("00" + dDate.getSeconds()).slice(-2);
      sDate = "" + sDay + " " + sMonth + " " + sHours + ":" + sMinutes + ":" + sSeconds;
      if (sContext) {
        sMessage = "[" + sContext + "] " + sMessage;
      }
      sMessage = (function() {
        switch (iLevel) {
          case this.ERROR:
            return clc.red.bold(sMessage);
          case this.WARNING:
            return clc.yellow(sMessage);
          case this.INFO:
            return clc.green(sMessage);
          case this.DEBUG:
            return clc.blackBright(sMessage);
          default:
            return clc.blackBright(sMessage);
        }
      }).call(this);
      return console.log("" + sDate + " " + sMessage);
    }
  };

  Glogger.prototype.verbose = function(sMessage, sContext) {
    if (sContext == null) {
      sContext = this._sContext;
    }
    return this.log(sMessage, sContext, this.VERBOSE);
  };

  Glogger.prototype.debug = function(sMessage, sContext) {
    if (sContext == null) {
      sContext = this._sContext;
    }
    return this.log(sMessage, sContext, this.DEBUG);
  };

  Glogger.prototype.info = function(sMessage, sContext) {
    if (sContext == null) {
      sContext = this._sContext;
    }
    return this.log(sMessage, sContext, this.INFO);
  };

  Glogger.prototype.warning = function(sMessage, sContext) {
    if (sContext == null) {
      sContext = this._sContext;
    }
    return this.log(sMessage, sContext, this.WARNING);
  };

  Glogger.prototype.error = function(sMessage, sContext) {
    if (sContext == null) {
      sContext = this._sContext;
    }
    return this.log(sMessage, sContext, this.ERROR);
  };

  return Glogger;

})();

oGlobalLogger = null;

factoryLogger = function(mConfig) {
  var oLogger;
  oLogger = new Glogger(mConfig);
  if (oGlobalLogger == null) {
    oGlobalLogger = oLogger;
  }
  return oLogger;
};

module.exports = factoryLogger;
