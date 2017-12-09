var pluginMD5 = new Object();

pluginMD5.encrypt = function(argc, successCallback){
    window.webkit.messageHandlers.encrypt.postMessage(argc);
    
    pluginMD5.successCallback = successCallback;
};

pluginMD5.encryptCallback = function(callbackObj){
    pluginMD5.successCallback(callbackObj);
};
