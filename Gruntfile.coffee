"use strict"

module.exports = ( grunt ) ->

    require( "matchdep" ).filterDev( "grunt-*" ).forEach grunt.loadNpmTasks

    grunt.initConfig
        coffeelint:
            options:
                arrow_spacing:
                    level: "error"
                camel_case_classes:
                    level: "error"
                duplicate_key:
                    level: "error"
                indentation:
                    level: "error"
                    value: 4
                max_line_length:
                    level: "ignore"
                no_backticks:
                    level: "error"
                no_empty_param_list:
                    level: "error"
                no_stand_alone_at:
                    level: "error"
                no_tabs:
                    level: "error"
                no_throwing_strings:
                    level: "error"
                no_trailing_semicolons:
                    level: "error"
                no_unnecessary_fat_arrows:
                    level: "error"
                space_operators:
                    level: "error"
            lib:
                files:
                    src: [ "lib/glogger.coffee" ]
        coffee:
            options:
                bare: yes
            lib:
                files:
                    "lib/glogger.js": "lib/glogger.coffee"
        jshint:
            options:
                curly: yes
                eqeqeq: yes
                immed: yes
                newcap: yes
                noarg: yes
                sub: yes
                undef: yes
                unused: yes
                boss: yes
                eqnull: yes
                node: yes
                "-W030": yes
                "-W004": yes
            lib:
                src: [ "lib/glogger.js" ]
        bumpup: "package.json"
        watch:
            lib:
                files: "lib/glogger.coffee"
                tasks: [
                    "coffeelint"
                    "coffee"
                    "jshint"
                    "bumpup:prerelease"
                ]

    grunt.registerTask "default", [
        "coffeelint"
        "coffee"
        "jshint"
        "bumpup:prerelease"
    ]
