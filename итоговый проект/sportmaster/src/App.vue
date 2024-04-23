<script>
import Appbar from "./components/base/Appbar.vue";
import AppSidebar from "./components/base/AppSidebar.vue";
import AppLoadingMask from './components/base/AppLoadingMask.vue'
import { authStore } from "./store/modules/auth";
export default{
  name:"App",
  components:{
      Appbar,
      AppSidebar,
      AppLoadingMask,
  },
  setup(){
      const store = authStore()
      return {store}
  },
  async created() {
      //await this.$store.dispatch("auth/getSession"); //аутентификация
      //this.$store.dispatch("auth/getUser"); //получение текущего пользователя (AD login)
  }
}
</script>

<template>
  <div class="bg-primary">
      <AppLoadingMask class="border-noround"></AppLoadingMask>
      <div v-if="store.$state.session">
        <Appbar class="border-noround shadow-2"></Appbar>
        <AppSidebar></AppSidebar>
        <Panel class="border-noround p-0">
          <router-view></router-view>
        </Panel>
      </div>
  </div>
</template>

