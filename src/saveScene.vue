<template>
    <span>
        <b-modal ref="saveModal" title="Neue Scene" show :okDisabled="newSceneName == ''" @ok="saveScene">
            <b-input v-model="newSceneName"/>
        </b-modal>
        <b-button @click="$refs.saveModal.show()" class="mx-1" variant="info">Neu</b-button>
    </span>
</template>

<script>
import axios from "axios"
export default {
  name: 'saveScene',
  data(){
    return {
        newSceneName: ""
    };
  },
  props:["scenes"],
  components: {

  },
  created(){
  },
  methods:{
    saveScene(){
        axios.get("http://wohnzimmerlampe/saveScene",{
            params: {
                name: this.newSceneName
            }
        }).then(() => {
            this.$emit("new",this.newSceneName);
        });
        this.$refs.saveModal.hide();
    }
  }
}
</script>
