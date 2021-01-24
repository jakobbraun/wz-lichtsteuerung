<template>
    <span>
        <b-modal ref="editModal" title="Scene bearbeiten" show ok-only>
            <template v-if="state != null">
                <div class="my-2">Alle zusammen: </div>
                <b-input v-model="general" type="range" :min="0" :max="255" class="my-2"/>
                <div class="my-2">Einzelene Lampen:</div>
                <b-input v-for="index in numLamps" v-model="state[index - 1]" type="range" :min="0" :max="255" class="my-2"/>
                <div class="my-2">Stripe:</div>
                <rgbColorPicker v-model="rgbwColor" />
            </template>
        </b-modal>
        <b-button @click="open" class="mx-1" variant="info">Bearbeiten</b-button>
    </span>
</template>

<script>
import axios from "axios"
import rgbColorPicker from "./rgbColorPicker.vue";

export default {
  name: 'editScene',
  data(){
    return {
        state:null,
        invalid: false,
        saving: false,
        general:0,
        numLamps: 6
    };
  },
  props:[],
  components: {
    rgbColorPicker
  },
  created(){
  },
  methods:{
    open(){
    
        axios.get("http://wohnzimmerlampe/state").then(res => {
            this.state = res.data.split(",").filter(e => e != "");
        });
        this.$refs.editModal.show()
    },
    save(){
        this.invalid = true;
        if(this.saving){
            return;
        }
        this.saving = true;
        this.invalid = false;
        
        axios.get("http://wohnzimmerlampe/setState",{
            params: {
                state: this.state.join(",")
            }
        }).then(() => {
            this.saving = false;
            if(this.invalid){
                this.save();
            }
        });
    }
  },
  watch:{
    state(newS){
        this.save();
    },
    general(newG){
        for(var i = 0; i < this.numLamps; i++){
            this.$set(this.state,i, newG);
        }
    }
  },
  computed:{
    rgbwColor:{
        get(){
            if(this.state == null || this.state.length < this.numLamps + 3)
                return [];
            return [this.state[this.numLamps], this.state[this.numLamps + 1], this.state[this.numLamps + 2], this.state[this.numLamps + 3]];
        },
        set(rgbwColor){
            for(var i = 0; i < 4; i++){
                this.$set(this.state, this.numLamps + i, rgbwColor[i]);
            }
        }
    }
  }
}
</script>
