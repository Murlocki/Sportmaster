import api from '../api'

import Grade from '../../model/Grade'
import Course from '../../model/Course'

import { defineStore } from 'pinia'
export const gradeStore = defineStore('grade',{
    state:()=>({
        courses: new Map(),
        grades: [],
        newGradeDialog:false
    }),
    actions:{
        setCourses(courses){
            this.courses.clear()
            courses.forEach(course=>{
                this.courses.set(
                    course.code,
                    new Course(
                        course.code,
                        course.name,
                        course.dateStart,
                        course.dateEnd
                    )
                )
            })
        },
        setGrades(grades){
            this.grades = grades.map(grade =>{
                return new Grade(
                    grade.code,
                    grade.courseCode,
                    grade.studentCode,
                    grade.grade,
                    grade.gradeDate,
                    grade.isDelete
                )
            })
        },
        postGradeMut(grade){
            this.grades.push(
                new Grade(
                    grade.code,
                    grade.courseCode,
                    grade.studentCode,
                    grade.grade,
                    grade.gradeDate,
                    grade.isDelete
                )
            )
        },
        deleteSingleGrade(grade){
            const index = this.grades.indexOf(grade)
            grade.isDelete=1;
            this.grades.splice(index,1,grade);
        },
        //Actions
        async getCourses(){
            this.setCourses(await api.course())
            console.log(this.courses)
        },
        async getGrades(){
            this.setGrades(await api.grade())
            console.log(this.grades)
        },
        async postGrade(grade){
            this.postGradeMut(await api.postGrade(grade))
        },
        async putGrade(grade){
            console.log(grade)
            return await api.putGrade(grade.code,grade)
        },
        async deleteGrade(grade){
            if(!(await api.deleteGrade(grade.code)).resultCode){
                this.deleteSingleGrade(grade)
            }
        },
        async initData(){
            this.setGrades(await api.initData())
        }
    }
})