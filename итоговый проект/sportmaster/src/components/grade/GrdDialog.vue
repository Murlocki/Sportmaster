<script>
import { gradeStore } from '../../store/modules/grade'
import Grade from '../../model/Grade'
import { studentStore } from '../../store/modules/student'
import { useStore } from '../../store'
import { ref } from 'vue'
export default {
    name:'GrdDialog',
    setup() {
        const grade=gradeStore()
        const student = studentStore()
        const newGrade = new Grade(null,null,null,null,null,0)
        const rules = {
            grade: val => (val && !isNaN(val) && val >= 0 && val <= 25) || "число от 0 до 25"
        }

        const init = function(){
            newGrade.courseCode = null;
            newGrade.studentCode = null;
            newGrade.grade = null;
            grade.newGradeDialog=false;
        }
        const close = function(){
            init();
        }
        const courseCodeError=ref(false)
        const studentCodeError=ref(false)
        const gradeError=ref(false)
        const saveNewGrade = function(){
            courseCodeError.value=newGrade.courseCode===null? true:false
            studentCodeError.value=newGrade.studentCode===null?true:false
            gradeError.value= rules.grade(newGrade.grade)!==true?true:false
            if(newGrade.courseCode && newGrade.studentCode && rules.grade(newGrade.grade) === true){
                newGrade.grade = Number(newGrade.grade);
                grade.postGrade(newGrade);
                init();
            }
        }
        
        return {gradeError,studentCodeError,courseCodeError,student,grade,rules,newGrade,init,close,saveNewGrade}
    },
}
</script>
<template>
    <Dialog :class="'surface-50'" v-model:visible="grade.newGradeDialog" modal header="Новый грейд" :closeOnEscape="true">
        <div class="flex flex-column">
            <span class="p-text-secondary block mb-5">Введите новую оценку</span>
            <div class="flex align-items-center gap-3 mb-3">
                <label for="course" class="font-semibold w-6rem">Курс</label>
                <select class="flex-auto h-3rem text-lg" v-model="newGrade.courseCode" id="course" @change="console.log(newGrade.courseCode)" v-bind:class="courseCodeError? 'border-pink-500 border-3':'border-2 border-primary'">
                    <option v-bind:key="course.code" v-for="course in Array.from(grade.$state.courses.values())" :value="course.code">{{ course.name }}</option>
                </select>
            </div>
            <div class="flex align-items-center gap-3 mb-3">
                <label for="student" class="font-semibold w-6rem">Студент</label>
                <select class="flex-auto h-3rem text-lg" v-model="newGrade.studentCode" id="student" @change="console.log(newGrade.studentCode)" v-bind:class="studentCodeError? 'border-pink-500 border-3':'border-2 border-primary'">
                    <option v-bind:key="student.code" v-for="student in Array.from(student.$state.students.values())" :value="student.code">{{ student.fullName }}</option>
                </select>
            </div>
            <div class="flex align-items-center gap-3 mb-5">
                <label for="grade" class="font-semibold w-6rem">Грейд</label>
                <InputText class="bg-white" v-model="newGrade.grade" id="grade" autocomplete="off"  @change="console.log(newGrade.grade)" v-bind:class="gradeError? 'border-pink-500 border-3':'border-2 border-primary'" />
            </div>

            <div class="flex flex-row column-gap-2" style="width:100%">
                <Button @click="close">Закрыть</Button>
                <Button @click="saveNewGrade">Сохранить</Button>
            </div>
        </div>
    </Dialog>
</template>