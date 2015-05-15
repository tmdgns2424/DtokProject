/*
 * Copyright (c) 2014 PS&M. All rights reserved.
 */

//(function (window, $) {

    var _FILE_URL = "/jsp/filescript.jsp";

    var PSNMFile = function() {
        var wrap = $('<div style="display: ; width: 500px; height: 100px;"/>'); //none
        this._index = 0;
        this._form = $("<form/>").attr("method", "post").attr("enctype", "multipart/form-data").attr("action", _FILE_URL).appendTo(wrap);
        this._form.append($('<input name="psnm_file_' + this._index+++'" type="file"/>'))
        wrap.appendTo( $(".file-controls") );

        this._form.ajaxForm({
            complete: function (xhr) {
                alert("xhr.responseText\n\n" + xhr.responseText);
                var result = null;
                try {
                    result = eval(xhr.responseText);
                }
                catch (e) {
                    console.log(e);
                    alert("ERROR: File Upload ... Fail");
                    return
                }
                var handler = undefined;
                if (window.page_fileservice !== undefined) {
                    handler = window.page_fileservice
                }
                if (window.page_FileService !== undefined) {
                    handler = window.page_FilesSrvice
                }
                if (handler !== undefined) {
                    handler(xhr.statusText === "OK", result)
                }
                if (callback !== undefined) {
                    console.log("PSNMFile : callback\n\n" + callback);
                    callback(xhr.statusText === "OK", result)
                }
            },
            beforeSend: function () {},
            uploadProgress: function (event, position, total, percentComplete) {}
        });
    };
    PSNMFile.prototype.init = function(values) {
        this.clear();

        if (values === undefined) {
            return;
        }

        var pageInfo = $(values).alopexGrid("pageInfo");
        var length = pageInfo.dataLength;
        console.log("PSNMFile : pageInfo.dataLength = " + length);

        for (var i=0; i < length; i++) {
            this._form.append($('<input name="psnm_file_' + this._index+++'" type="file"/>'));
            console.log("PSNMFile : _index = " + this._index);
        }
        /*
        if (values === undefined) {
            return;
        }
        if (values.records !== undefined) {
            values = values.records;
        }
        for (var i = 0, length = values.length; i < length; i++) {
            this._form.append($('<input name="psnm_file_' + this._index+++'" type="file"/>'));
            alert("PSNMFile : _index = " + this._index);
        }
        */
    };
    PSNMFile.prototype.add = function (callback) {
        var that = this;
        var file = this._form.find('input[type="file"]:last');
        //if (file.data("psnm-handler") === undefined) {
            file.change(function () {
                console.log("file.change(function () : " + file.val());
                alert("file.val() = " + file.val());
                //alert("that._form = " + that._form);

                that._form.submit();
                /*
                that._form.append($('<input name="psnm_file_' + that._index+++'" type="file"/>'));
                var value = file.val(); //alert("file.size() = " + file.size());
                var index = value.lastIndexOf("\\");
                if (index === -1) {
                    index = value.lastIndexOf("/")
                }
                if (index !== -1) {
                    value = value.substr(index + 1)
                }
                var handler = undefined;
                if (window.page_FileAdd !== undefined) {
                    handler = window.page_FileAdd
                }
                if (window.page_fileadd !== undefined) {
                    handler = window.page_fileadd
                }
                if (handler !== undefined) {
                    handler(file);
                }
                if (callback !== undefined) {
                    //alert("PSNMFile.prototype.add : callback 함수 호출 : ");
                    callback(file); //callback(value);
                }
                */
            });
            file.data("psnm-handler", "");
        //}
        console.log("before file.click() : " + file.val());
        alert("before file.click(); " + file.val());
        file.click();
        console.log("after file.click() : " + file.val());
    };
    PSNMFile.prototype.remove = function(indexes) {

        for (var i = indexes.length - 1; i >= 0; i--) {
            alert(indexes[i]);
            //this._form.find('input[type="file"]:eq(' + indexes[i] + ")").remove()
        }
        /*
        if (indexes.length === undefined) {
            indexes = [indexes]
        }
        for (var i = indexes.length - 1; i >= 0; i--) {
            alert(indexes[i]);
            this._form.find('input[type="file"]:eq(' + indexes[i] + ")").remove()
        }
        var handler = undefined;
        if (window.page_fileremove !== undefined) {
            handler = window.page_fileremove
        }
        if (window.page_FileRemove !== undefined) {
            handler = window.page_FileRemove
        }
        if (handler !== undefined) {
            handler(indexes)
        }
        */
    };
    PSNMFile.prototype.clear = function () {
        this._form.find('input[type="file"]:not(:last)').remove()
    };
    PSNMFile.prototype.service = function (callback) {
        alert("this._form.children().length = " + this._form.children().length);
        if (this._form.children().length === 1) {
            var handler = undefined;
            if (window.page_fileservice !== undefined) {
                handler = window.page_fileservice
            }
            if (window.page_FileService !== undefined) {
                handler = window.page_FileService
            }
            if (handler !== undefined) {
                handler(true, [])
            }
            if (callback !== undefined) {
                callback(true, [])
            }
            return;
        }
        this._form.find('input[type="file"]:last').remove();
        this._form.ajaxForm({
            complete: function (xhr) {
                var result = null;
                try {
                    result = eval(xhr.responseText)
                } catch (e) {
                    console.log(e);
                    alert("ERROR: File Upload ... Fail");
                    return
                }
                var handler = undefined;
                if (window.page_fileservice !== undefined) {
                    handler = window.page_fileservice
                }
                if (window.page_FileService !== undefined) {
                    handler = window.page_FilesSrvice
                }
                if (handler !== undefined) {
                    handler(xhr.statusText === "OK", result)
                }
                if (callback !== undefined) {
                    callback(xhr.statusText === "OK", result)
                }
            },
            beforeSend: function () {},
            uploadProgress: function (event, position, total, percentComplete) {}
        });
        this._form.submit()
    };
    PSNMFile.prototype.getUrl = function (id) {
        return _FILE_URL + "?cmd=download&id=" + id + "&name=" + id
    };
    PSNMFile.prototype.download = function (id, name) {
        window.open(_FILE_URL + "?cmd=download&id=" + id + "&name=" + name)
    };

//})(jQuery);
