package org.flowplayer.audiovisual {
    
    import org.flowplayer.model.PluginFactory;
    import flash.display.Sprite;
    public class AudioVisualFactory extends Sprite implements PluginFactory {

        public function newPlugin():Object {
            return new AudioVisual();
        }
    }
}