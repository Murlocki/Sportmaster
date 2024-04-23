<script>
    import {authStore} from '../../store/modules/auth'
    import {ref} from 'vue'
    export default {
        name:'AppUserInfo',
        setup(){
            const store = authStore()
            const name = store.$state.user
            return { name }
        }
    }
</script>
<template>
    <div class="flex flex-row align-content-center column-gap-2">
        <span class="surface-500 border-circle px-3 py-0  ml-3 my-1 align-content-center " style="height:auto;width:auto;display:inline-block;">
            <i class="pi pi-user " style="font-size: 2rem"/>
        </span>
        <p class="text-color text-xl font-medium" style="font-family:inherit;">{{name}}</p>
    </div>
</template>

