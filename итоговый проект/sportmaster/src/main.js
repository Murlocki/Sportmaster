import { createApp } from 'vue';
import './style.css';
import App from './App.vue';

import 'primeflex/primeflex.css';
import 'primeicons/primeicons.css';
import PrimeVue from 'primevue/config';

import Button from "primevue/button";
import Toolbar from "primevue/toolbar";
import Sidebar from 'primevue/sidebar';
import Menu from 'primevue/menu'
import Image from 'primevue/image';
import Divider from 'primevue/divider';
import ProgressBar from 'primevue/progressbar';
import Dialog from 'primevue/dialog';
import Panel from 'primevue/panel';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import InputText from 'primevue/inputtext';
import Dropdown from 'primevue/dropdown';


import {createPinia} from 'pinia'
const pinia = createPinia()


import router from './router'

const app = createApp(App);
app.use(pinia)

app.use(PrimeVue, { ripple: true });
app.use(router);
app.component('Button', Button);
app.component("Toolbar",Toolbar);
app.component('Sidebar',Sidebar);
app.component('Menu',Menu);
app.component('Image',Image);
app.component('Divider',Divider);
app.component('ProgressBar',ProgressBar);
app.component('Dialog',Dialog);
app.component('Panel',Panel);
app.component('DataTable',DataTable);
app.component('Column',Column)
app.component('InputText',InputText)
app.component('Dropdown',Dropdown)
app.mount('#app');