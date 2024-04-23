
import { createMemoryHistory, createRouter } from 'vue-router'
import Grades from '../components/views/Grades.vue'
import Second from '../components/views/Second.vue'


const routes = [
    {
        path: '/',
        name: 'Grades',
        component: Grades
    },
    {
        path: '/second',
        name: 'SecondView',
        // route level code-splitting
        // this generates a separate chunk (about.[hash].js) for this route
        // which is lazy-loaded when the route is visited.
        component: () => import(/* webpackChunkName: "second" */ '../components/views/Second.vue')
    }
]

const router = new createRouter({
    history: createMemoryHistory(),
    routes
})

export default router