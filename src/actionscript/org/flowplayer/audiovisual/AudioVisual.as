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

  import org.flowplayer.model.ClipEvent;
  import org.flowplayer.model.PluginEvent;
  import org.flowplayer.model.PluginEventType;
  import org.flowplayer.model.DisplayPluginModel;
  import org.flowplayer.model.DisplayProperties;
  import org.flowplayer.model.DisplayPropertiesImpl;
  import org.flowplayer.model.Plugin;
  import org.flowplayer.model.PluginModel;
  import org.flowplayer.util.PropertyBinder;
  import org.flowplayer.util.Log;
  import org.flowplayer.view.Flowplayer;

  public class AudioVisual implements Plugin {

    private var _model:PluginModel;
    private var _player:Flowplayer;
    private var _config:Object;
    private var timer:Timer;
    private var sp:SoundProcessor;
    private var log:Log = new Log(this);


    public function onConfig(model:PluginModel):void {
      log.debug('onConfig audiovisual');
      _model = model;
      _config = model.config;
    }

    public function onLoad(player:Flowplayer):void {
      log.debug("onLoad() AudioVisual");
      _player = player;
      sp = new SoundProcessor();
      timer = new Timer(_config.freq || 50);
      timer.addEventListener(TimerEvent.TIMER, calculate);

      player.playlist.onStart(startTimer);
      player.playlist.onResume(startTimer);
      player.playlist.onStop(stopTimer);
      player.playlist.onPause(stopTimer);
      _model.dispatchOnLoad();
    }

    private function calculate(e:TimerEvent):void {
      //False since we don't want fourier transformation
      var soundArray:Array = sp.getSoundSpectrum(_config.fft);
      if (soundArray.length) {
        _model.dispatch(PluginEventType.PLUGIN_EVENT, "onSound", soundArray);
      }
    }

    private function startTimer(event:ClipEvent = null):void {
      timer.start();
      log.debug("Timer started");
    }

    private function stopTimer(event:ClipEvent):void {
      timer.stop();
      log.debug("Timer stopped");
    }

    public function getDefaultConfig():Object {
      return {};
    }
  }
}