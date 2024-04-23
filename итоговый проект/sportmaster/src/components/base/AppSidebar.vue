<script>
import {ref,computed} from 'vue'
import { useStore } from '../../store';
import AppLogo from './AppLogo.vue'
import AppUserInfo from './AppUserInfo.vue';
export default {
    name:'AppSidebar',
    components:{
        AppLogo,
        AppUserInfo
    },
    setup() {
        const store = useStore()
        const visible = computed({
            get(){
                return store.$state.drawer
            },
            set(){ store.toggleDrawer()}

        });
        const items = ref([
                {
                    title: "Грейды",
                    icon: "pi pi-table",
                    route: "/"
                },
                {
                    title: "Представление 2",
                    icon: "pi pi-comments",
                    route: "/second"
                }
        ])
        return {visible,items}
    },
}
</script>

<template>
        <Sidebar v-model:visible="visible" :modal="false" class="p-sidebar surface-50">
            <template #container>
                <Menu :model="items" class="p-0" :style="'width:auto'">
                    <template #start>
                        <AppLogo></AppLogo>
                        <AppUserInfo></AppUserInfo>
                        <Divider class="mb-2 mt-0"/>
                    </template>
                    <template #item="{ item }">
                        <router-link :to="item.route">
                            <Button class="p-button p-button-lg surface-50 hover:surface-100 text-color text-left border-0" :style="'width:100%'" :icon="item.icon" :label="item.title" />
                        </router-link>
                    </template>
                </Menu>
            </template>
            
        </Sidebar>
</template>