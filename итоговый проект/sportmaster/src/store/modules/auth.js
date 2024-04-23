import api from '../api'

import { defineStore } from 'pinia'
export const authStore = defineStore('auth',{
    state: ()=>({
        session:true,
        user:'Студент'
    }),
    actions:{
        setSession(data){
            this.session=data.sessionId
        },
        setUser(data){
            state.user=data.user
        },
        async getSession(){
            this.setSession(await api.auth.getSession())
        },
        async getUser(){
            this.setUser(await api.auth.getUser())
        }
    },
})