import { defineStore } from 'pinia'
import { authStore } from './modules/auth';
import { studentStore } from './modules/student';
import { gradeStore } from './modules/grade';
export const useStore = defineStore('store',{
    state: ()=> ({
        drawer : false,
        isLoading : false,
    }),
    actions: {
            toggleDrawer(){
                this.drawer = !this.drawer;
            },
            setIsLoading(flag){
                this.isLoading=flag;
            }
    },
})
