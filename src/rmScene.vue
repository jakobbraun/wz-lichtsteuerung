<template>
    <span>
        <b-modal ref="rmModal" title="Scene löschen" show :okDisabled="selectedScene == ''" @ok="rmScene">
            <b-form-select :options="scenes" v-model="selectedScene"/>
        </b-modal>
        <b-button @click="$refs.rmModal.show()" variant="danger">Scene löschen</b-button>
    </span>
</template>

<script>
import axios from "axios"
export default {
  name: 'rmScene',
  data(){
    return {
        selectedScene: null
    };
  },
  props:["scenes"],
  components: {

  },
  created(){
  },
  methods:{
    rmScene(){
        axios.get("http://wohnzimmerlampe/rmScene",{
            params: {
                name: this.selectedScene
            }
        }).then(() => {
            this.$emit("deleted",this.selectedScene);
        });
        this.$refs.rmModal.hide();
    }
  }
}
</script>
