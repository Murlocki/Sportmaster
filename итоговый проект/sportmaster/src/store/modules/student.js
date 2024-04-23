import api from '../api'
import Student from '../../model/Student'


import { defineStore } from 'pinia'
export const studentStore = defineStore('student',{
    state: ()=>({
        students: new Map()
    }),
    actions:{
        setStudents(data){
            data.forEach(student =>{
                this.students.set(
                    parseInt(student.code),
                    new Student(
                        student.code,
                        student.fullName,
                        student.datetime
                    )
                )
            })
        },
        async getStudents(){
            await this.setStudents(await api.student())
        } 
    },

})