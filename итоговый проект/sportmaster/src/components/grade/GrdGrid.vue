<script>
import { ref,computed } from 'vue'
import { useStore } from '../../store'
import { gradeStore } from '../../store/modules/grade'
import { studentStore } from '../../store/modules/student'
import Dropdown from 'primevue/dropdown'
import Button from 'primevue/button'
export default {
    name:'GrdGrid',
    setup() {
        const headers = ref([
            {id:1,header: "Код", value: "code",sortable: true},
            {id:2,header: "Курс", value: "courseName",sortable: true},
            {id:3,header: "ФИО", value: "studentName",sortable: true},
            {id:4,header: "Грейд", value: "grade",sortable: true},
            {id:5,header: "Дата", value: "formatGradeDate",sortable: true},
        ])

        const rules = {
            grade: val => (val && !isNaN(val) && val >= 0 && val <= 25) || "число от 0 до 25"
        }

        const currentGradeValue = ref(null)


        //Методы

        const store = gradeStore()
        const actualGrades = computed(()=>{
            return store.$state.grades.filter(grade => !grade.isDelete);
        })

        const open = function(value){
            currentGradeValue.value = value;
            console.log(currentGradeValue.value)
        }   

        const save = async function(edit){
            let isError = 1;
            if (rules.grade(currentGradeValue.value) === true) {
                try {
                    edit.data.grade = Number(currentGradeValue.value);
                    console.log(1)
                    console.log(edit.data.grade)
                    isError = (await store.putGrade(edit.data)).resultCode;

                } catch (error) {
                    console.error(error);
                }
            }
            
            setTimeout(() => (edit.data.grade = isError ? currentGradeValue : Number(edit.data.grade)));
        }
        const deleteItem = function(grade){
            store.deleteGrade(grade)
        }
        const initData = function(){
            store.initData()
        }
        return { store,  headers, rules, currentGradeValue, actualGrades, open,save,deleteItem,initData }
    },
    async mounted(){
        const store = gradeStore()
        await store.getCourses()

        const students=studentStore()
        await students.getStudents()
        console.log(students.$state.students)
        console.log(store.$state.courses)
        await store.getGrades()
        console.log(store.$state.grades)
    }
}
</script>
<template>
    <div class="shadow-3 p-0 m-0">
        <DataTable class="z-1" :value="actualGrades" :rows="10" :paginator="true" responsiveLayout="stack" editMode="cell" @cell-edit-complete="save" :sortMode="'multiple'">
            <template #header>
                <div class="flex align-items-center justify-content-between m-0 p-datatable-header">
                    <span class="text-xl text-900 font-bold">Таблица грейдов</span>
                    <Button class="p-button-md" severity="secondary" icon="pi pi-plus" rounded raised @click="store.$state.newGradeDialog = true"/>
                </div>
            </template>
            <Column v-for="header in headers" :key="header.id" :header="header.header" :sortable="header.sortable" :field="header.value" :editMode="'cell'">
                <template v-if="header.header == 'Грейд'" #editor>
                    <InputText v-model="currentGradeValue"/>
                </template>
            </Column>
            <Column :header="'Удалить'" :key="headers.size" >
                <template #body="slotProps">
                    <Button icon="pi pi-trash" class="p-button-rounded p-button-outlined p-button-danger ml-3" @click="deleteItem(slotProps.data)"/>
                </template>
            </Column>
        </DataTable>
        <Button v-if="actualGrades.size===0" @click="initData">Загрузить данные заново</Button>
    </div>
    
</template>
