<template>
        <Toolbar class="surface-50">
            <template #start>
                <div style="display:flex;justify-content: start;align-items:center; column-gap: 10px;" >
                    <Button class="p-ripple p-button-lg" severity="secondary" text icon="pi pi-bars" @click="toggleDraw" />
                    <span class="text-color text-2xl">КубГу</span>
                </div>
            </template>
            <template #end>
                <Button class="p-ripple p-button-lg" v-bind:icon="currentTheme=='pi-moon'? 'pi pi-moon':'pi pi-sun'" text raised rounded @click="changeTheme"/>      
            </template>
        </Toolbar>
</template>

<script>
import { ref } from 'vue';
import { usePrimeVue } from 'primevue/config';
import { useStore } from '../../store'
export default{
    name:"Appbar",
    setup() {

        const PrimeVue = usePrimeVue();

        const currentTheme = ref("pi-moon")

        const changeTheme = ()=>{
            if(currentTheme.value=="pi-moon"){
                PrimeVue.changeTheme('aura-light-noir', 'aura-dark-noir', 'theme-link', () => {});
                currentTheme.value = 'pi-sun'
            }
            else{
                PrimeVue.changeTheme('aura-dark-noir', 'aura-light-noir', 'theme-link', () => {});
                currentTheme.value = 'pi-moon'
            }
        }
        
        const store = useStore()
        const toggleDraw = ()=>{
            store.toggleDrawer()
        }

        return {currentTheme,changeTheme,toggleDraw}
    },
}
</script>
