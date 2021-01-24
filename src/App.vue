<template>
  <div id="app">
    <div class="scene" v-for="scene in scenes" @click="loadScene(scene)">{{scene}}</div>
    <div class="my-4">
        <saveScene :scenes="scenes" @new="newScene"/>
        <rmScene :scenes="scenes"  @deleted="rmScene"/>
        <editScene />
    </div>
  </div>
</template>

<script>
import axios from "axios"
import saveScene from "./saveScene.vue"
import rmScene from "./rmScene.vue"
import editScene from "./editScene.vue"

export default {
  name: 'app',
  data(){
    return {
        scenes: [],
    };
  },
  components: {
    saveScene,
    rmScene,
    editScene
  },
  created(){
    axios.get("http://wohnzimmerlampe/scenes").then(resp => this.scenes = resp.data.split("\n").filter(e => e != ""));
  },
  methods:{
    loadScene(name){
        axios.get("http://wohnzimmerlampe/loadScene",{
            params: {
                name: name
            }
        });
    },
    newScene(name){
        this.scenes.push(name);
    },
    rmScene(name){
        this.scenes.splice(this.scenes.indexOf(name),1);
    }
  },
}
</script>

<style scoped>
.scene{
    padding: 7px;
    border-radius: 4px;
    background: #ddd;
    display:inline-block;
    margin: 6px;
    cursor: pointer;
}
</style>
