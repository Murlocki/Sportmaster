
import Formatter from "../utils/Formatter"
import { gradeStore } from "../store/modules/grade"
import { studentStore } from "../store/modules/student"
export default class Grade {
    code
    courseCode
    studentCode
    grade
    gradeDate
    isDelete
    constructor(code, courseCode, studentCode, grade, gradeDate, isDelete) {
        this.code = code;
        this.courseCode = courseCode;
        this.studentCode = studentCode;
        this.grade = grade;
        this.gradeDate = gradeDate;
        this.isDelete = 0;
    }
    
    get courseName() {
        const store=gradeStore()
        return store.$state.courses.get(this.courseCode).name;
    }

    get studentName() {
        const studStore=studentStore()
        return studStore.$state.students.get(this.studentCode).fullName;
    }
    get formatGradeDate() {
        return Formatter.formatDate(this.gradeDate);
    }
}