<script>
export default {
    name:'AppLogo',
    setup(){

    }
}
</script>
<template>
    <router-link to="/">
        <Button class="p-2 m-0 bg-blue-500" :style="'width:100%;border-radius:0px;border:0px'" >
            <span class="p-0 m-0">
                <Image src="/src/assets/images/logo_gavr.png" alt="Image" width="90" height="45"/>
            </span>
        </Button>
    </router-link>
</template>
