<script>
import GrdDialog from '../grade/GrdDialog.vue';
import GrdGrid from '../grade/GrdGrid.vue'
    export default{
        components:{
            GrdGrid,
            GrdDialog
        },
        name:'Grades'
    }
</script>
<template>
    <div>
        <GrdGrid></GrdGrid>
        <GrdDialog></GrdDialog>
    </div>
</template>