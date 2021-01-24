<template>
    <div>
        <color-picker v-bind="color" @input="onInput" style="margin: 0 auto;"></color-picker>
        <b-input v-model="color.saturation" type="range" :min="0" :max="100" class="my-2"/>
        <b-input v-model="color.luminosity" type="range" :min="0" :max="100" class="my-2"/>
        <b-input v-model="color.white" type="range" :min="0" :max="255" class="my-2"/>
    </div>
</template>

<script>
import ColorPicker from '@radial-color-picker/vue-color-picker';

export default {
  name: 'rgbColorPicker',
  props:["value"],
  data(){
    return {
        color: {
            hue: 50,
            saturation: 100,
            luminosity: 50,
            white: 0,
            alpha: 1
        },
    };
  },
  components: {
    ColorPicker
  },
  methods:{
    onInput(hue){
        this.color.hue = hue;
    },
    setRgb(rgbColor){
        var r = rgbColor[0] / 255;
        var g = rgbColor[1] / 255;
        var b = rgbColor[2] / 255;

        var max = Math.max(r, g, b), min = Math.min(r, g, b);
        var h, s, v = max;

        var d = max - min;
        s = max == 0 ? 0 : d / max;

        if (max == min) {
            h = 0; // achromatic
        } else {
            switch (max) {
            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
            case g: h = (b - r) / d + 2; break;
            case b: h = (r - g) / d + 4; break;
            }

            h /= 6;
        }

        this.color.hue = h * 360;
        this.color.saturation = s * 100;
        this.color.luminosity = v * 100;
        this.color.white = rgbColor[3];
    
    }
  },
  watch:{
    color:{
        handler(newColor){
            var h = newColor.hue / 360;
            var s = newColor.saturation / 100;
            var v = newColor.luminosity / 100;
            var r, g, b;

            var i = Math.floor(h * 6);
            var f = h * 6 - i;
            var p = v * (1 - s);
            var q = v * (1 - f * s);
            var t = v * (1 - (1 - f) * s);

            switch (i % 6) {
                case 0: r = v, g = t, b = p; break;
                case 1: r = q, g = v, b = p; break;
                case 2: r = p, g = v, b = t; break;
                case 3: r = p, g = q, b = v; break;
                case 4: r = t, g = p, b = v; break;
                case 5: r = v, g = p, b = q; break;
            }

            this.$emit("input",[r*255,g*255,b*255, newColor.white]);
        },
        deep:true
    },
    value(rgbColor){
    //return;
        this.setRgb(rgbColor);
    },
  },
  created(){
    this.setRgb(this.value);
  }
}
</script>

<style>
@import '~@radial-color-picker/vue-color-picker/dist/vue-color-picker.min.css';
</style>
