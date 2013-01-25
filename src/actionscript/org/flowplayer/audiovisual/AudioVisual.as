/*
 * This file is part of Flowplayer, http://flowplayer.org
 *
 * By: Anssi Piirainen, <support@flowplayer.org>
 * Copyright (c) 2008, 2009 Flowplayer Oy
 *
 * Released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.flowplayer.audiovisual {
    import com.iheart.sound.SoundProcessor;

    import flash.utils.*;
    import flash.events.*;
    
    import org.flowplayer.util.Log;
    
    import org.flowplayer.model.ClipEvent;
    import org.flowplayer.model.PluginEvent;
    import org.flowplayer.model.PluginEventType;
    import org.flowplayer.model.DisplayPluginModel;
    import org.flowplayer.model.DisplayProperties;
    import org.flowplayer.model.DisplayPropertiesImpl;
    import org.flowplayer.model.Plugin;
    import org.flowplayer.model.PluginModel;
    import org.flowplayer.util.PropertyBinder;
    import org.flowplayer.view.Flowplayer;

    public class AudioVisual implements Plugin {
        
        private var _model:PluginModel;
        private var _player:Flowplayer;
        private var _interval:uint;
        private var timer:Timer;
        private var _soundArray:Array;
        private var sp:SoundProcessor;
        private var log:Log = new Log(this);

        

        public function onConfig(model:PluginModel):void {
            log.debug('onConfig audiovisual');
            _model = model;
            /*
            _config = new PropertyBinder(new Config(), null).copyProperties(model.config) as Config;
            */
        }

        public function onLoad(player:Flowplayer):void {
            log.debug("onLoad() AudioVisual");
            _player = player;
            sp = new SoundProcessor();
            timer = new Timer(200);  
            timer.addEventListener(TimerEvent.TIMER, calculate);  
            
            
            player.playlist.onStart(show);
            player.playlist.onStop(hide);
            player.playlist.onPause(hide);
            /*
            player.playlist.onResume(show);
            player.playlist.onFinish(hide);
            
            player.playlist.onPause(hide);
            */
            _model.dispatchOnLoad();
            
        }

        private function calculate(e:TimerEvent):void {
            _model.dispatch(PluginEventType.PLUGIN_EVENT, "onSound", sp.getSoundSpectrum(false));
        }


        private function show(event:ClipEvent = null):void {
            log.debug("show()");
            timer.start(); 
        }

        private function hide(event:ClipEvent):void {
            log.debug("hide()");
            timer.stop();
        }

        public function getDefaultConfig():Object {
            return {};
        }
    }
}